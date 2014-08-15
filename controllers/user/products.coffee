async = require 'async'
_ = require 'underscore'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
Product = require '../../lib/product'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'products'
	
	async.waterfall [
		(next) ->
			Product.makeSearchOptions req.params.category, req.params.age, next
		(searchOptions, next) ->
			Model 'Product', 'find', next, searchOptions
		(docs, next) ->
			Model 'Product', 'populate', next, docs, 'age category'
		(docs, next) ->
			data.products = docs
			
			next()
		(next) ->
			Product.getAgesAndCategories next
		(results) ->
			data.ages = results.ages
			data.categories = results.categories

			_.each data.products, (item, key, list)->
				volume = item.getFormattedVolume()
				list[key] = item.toObject()
				list[key].volume = volume
			
			View.render 'user/products/products', res, data, req.path
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/products/index: #{error}"

exports.findAll = (req, res) ->
	data = {}
	
	async.waterfall [
		(next) ->
			Product.makeSearchOptions req.body.category, req.body.age, next
		(searchOptions, next) ->
			Model 'Product', 'find', next, searchOptions
		(docs, next) ->
			Model 'Product', 'populate', next, docs, 'age category'
		(docs, next) ->
			data.products = docs
			
			next()
		(next) ->
			_.each data.products, (item, key, list)->
				volume = item.getFormattedVolume()
				list[key] = item.toObject()
				list[key].volume = volume

			View.ajaxResponse res, null, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/products/findAll: #{error}"
		View.ajaxResponse res, err