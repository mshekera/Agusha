async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
Product = require '../../lib/product'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'product'
	
	async.waterfall [
		(next) ->
			Model 'Product', 'findById', next, req.params.id
		(doc, next) ->
			Model 'Product', 'populate', next, doc, 'age certificate'
		(doc) ->
			data.product = doc
			
			data.breadcrumbs.push
				parent_id: 'product'
				title: data.product.title
			
			View.render 'user/product/product', res, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/product/index: #{error}"
	