async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
Article = require '../../lib/article'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'food'
	
	async.waterfall [
		(next) ->
			async.parallel
				article: (next2) ->
					Model 'Article', 'findById', next2, req.params.id
				articles: (next2) ->
					Model 'Article', 'find', next2, type: 2, 'desc_title'
			, next
		(results) ->
			data.article = results.article
			data.articles = results.articles
			
			data.breadcrumbs.push
				parent_id: 'food'
				title: data.article.desc_title
			
			View.render 'user/article/article', res, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/article/index: #{error}"

exports.specialist = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'food'
	
	async.waterfall [
		(next) ->
			async.parallel
				article: (next2) ->
					Model 'Article', 'findById', next2, req.params.id
				articles: (next2) ->
					Model 'Article', 'find', next2, type: 3, 'desc_image big_title'
			, next
		(results) ->
			data.article = results.article
			data.articles = results.articles
			
			data.breadcrumbs.push
				parent_id: 'food'
				title: data.article.desc_title
			
			View.render 'user/article/article', res, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/article/specialist: #{error}"