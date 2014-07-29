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
			Model 'Article', 'find', next, type: 2
		(docs, next) ->
			data.articles = docs
			
			View.render 'user/food/food', res, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/food/index: #{error}"