async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'food'
	
	async.waterfall [
		(next) ->
			async.parallel
				articles: (next2) ->
					Model 'Article', 'find', next2, type: 2
				specialist: (next2) ->
					Model 'Article', 'findOne', next2, type: 3
			, next
		(results, next) ->
			data.articles = results.articles
			data.specialist = results.specialist
			
			View.render 'user/food/food', res, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/food/index: #{error}"