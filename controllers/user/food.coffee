async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

findArticlesAndSpecialist = (callback) ->
	async.parallel
		articles: (next) ->
			findOptions =
				type: 2
				active: true
			
			Model 'Article', 'find', next, findOptions
		specialist: (next) ->
			findOptions =
				type: 3
				active: true
			
			Model 'Article', 'findOne', next, findOptions
	, callback

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'food'
	
	async.waterfall [
		(next) ->
			findArticlesAndSpecialist next
		(results, next) ->
			data.articles = results.articles
			data.specialist = results.specialist
			
			View.render 'user/food/food', res, data, req.path
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/food/index: #{error}"
		res.send error