async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

falseObjectID = '111111111111111111111111'

exports.index = (req, res) ->
	category = req.params.category
	age = req.params.age
	
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'products'
	
	searchOptions = {}
	
	asyncFunctions = []
	
	if category
		asyncFunctions = asyncFunctions.concat [
			(next) ->
				Model 'Category', 'findOne', next, {url_label: category}
			(doc, next) ->
				if doc
					searchOptions.category = doc._id
				else
					searchOptions.category = falseObjectID
				next()
		]
	
	if age
		asyncFunctions = asyncFunctions.concat [
			(next) ->
				Model 'Age', 'findOne', next, {level: age}
			(doc, next) ->
				if doc
					searchOptions.age = doc._id
				else
					searchOptions.age = falseObjectID
				next()
		]
	
	asyncFunctions = asyncFunctions.concat [
		(next) ->			
			Model 'Product', 'find', next, searchOptions
		(docs, next) ->			
			Model 'Product', 'populate', next, docs, 'age category'
		(docs) ->
			data.products = docs
			
			View.render 'user/products/products', res, data
	]
	
	async.waterfall asyncFunctions, (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/products/index: #{error}"