async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
Article = require '../../lib/article'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'news'
	
	async.waterfall [
		(next) ->
			Model 'Article', 'findNews', next, true
		(docs, next) ->
			docs = Article.preformatDate docs
			
			data.articles = docs
			
			View.render 'user/news/news', res, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/news/index: #{error}"
		res.redirect '/'