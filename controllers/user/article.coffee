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
			Model 'Article', 'findById', next, req.params.id
		(doc) ->
			data.article = doc
			
			data.breadcrumbs.push
				parent_id: 'food'
				title: data.article.desc_title
			
			View.render 'user/article/article', res, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/article/index: #{error}"