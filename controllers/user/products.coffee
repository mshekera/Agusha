async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'products'
	
	async.waterfall [
		(next) ->			
			Model 'Product', 'find', next
		(docs, next) ->			
			Model 'Product', 'populate', next, docs, 'age category'
		(docs) ->
			data.products = docs
			
			View.render 'user/products/products', res, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/products/index: #{error}"