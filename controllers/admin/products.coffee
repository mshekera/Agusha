async = require 'async'
_ = require 'underscore'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
mongoose = require 'mongoose'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Product', 'find', next
		(docs, next) ->
			opts = 
				path: 'age certificate category'

			Model 'Product', 'populate', next, docs, opts
		(docs) ->
			View.render 'admin/board/products/index', res, {products: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/products/index: %s #{err.message or err}"

findExisting = (real, all) ->
	return if real is undefined or real.length is 0
	realExists = []

	for realItem in real
		realExists.push realItem

	for allItem in all
		for existsItem in realExists
			if existsItem.toString() == allItem._id.toString()
				allItem.exists = true
				break

preloadData = (product, cb) ->
	if typeof product is 'function'
		cb = product
		product = {}

	async.parallel
		categories: (next) ->
			Model 'Category', 'find', next, active: true
		ages: (next) ->
			Model 'Age', 'find', next, active: true
		certificates: (next)->
			Model 'Certificate', 'find', next
	, (err, results)->
		cb err if err

		results.product = product

		findExisting product.category, results.categories 
		findExisting product.certificate, results.certificates

		if product.age
			for age in results.ages
				if age._id.toString() == product.age.toString()
					age.exists = true

		cb null, results

exports.get = (req, res) ->
	_id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Product', 'findOne', next, _id: _id
		preloadData
		(results) ->
			View.render 'admin/board/products/edit', res, results
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/products/get: %s #{err.message or err}"

exports.create = (req, res) ->
	async.waterfall [
		preloadData
		(results) ->
			View.render 'admin/board/products/edit', res, results
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/products/create: %s #{err.message or err}"


exports.save = (req, res) ->
	_id = req.body.id

	data = req.body
	delete data._wysihtml5_mode if data._wysihtml5_mode

	data.image = req.files?.image?.name or ""

	if data['certificate[]']
		data.certificate = data['certificate[]']
		delete data['certificate[]']

	if data['category[]']
		data.category = data['category[]']
		if typeof data.category isnt 'object'
			data.category = [data.category]
		delete data['category[]']

	async.waterfall [
		(next) ->
			if _id
				async.waterfall [
					(next2) ->
						Model 'Product', 'findOne', next2, _id: _id
					(doc, next2) ->
						for own prop, val of data
							unless prop is 'id' or val is undefined
								doc[prop] = val

						doc.active = data.active or false

						doc.save next

				], (err) ->
					next err
			else
				Model 'Product', 'create', next, data

		(doc, affected, next) ->
			if typeof affected is 'function'
				next = affected

			if data.category
				async.waterfall [
					(next2) ->
						Model 'ProductPosition', 'find', next2, p_id: doc._id
					(cats, next2) ->
						catIdObjs = _.pluck cats, 'c_id'
						catsOld = _.map catIdObjs, (val) ->
							val.toString()

						catsToRemove = []
						catsToAdd = []

						for cat in data.category
							if catsOld.indexOf(cat) is -1
								catsToAdd.push cat

						for cat in catsOld
							if data.category.indexOf(cat) is -1
								catsToRemove.push cat

						async.parallel [
							(cb) ->
								iterator = (item, cb2) ->
									Model 'ProductPosition', 'remove', cb2, 
										p_id: doc._id
										c_id: item

								callback = (err) ->
									console.log 'error', err
									cb err

								async.each catsToRemove, iterator, callback

							(cb) ->
								iterator = (item, cb2) ->
									Model 'ProductPosition', 'create', cb2, 
										p_id: doc._id
										c_id: item
										position: 0

								callback = (err) ->
									cb err

								async.each catsToAdd, iterator, callback

						], (err, results) ->
							next err, doc
				], (err) ->
					next err
			else
				next null, doc

		(doc, next) ->
			unless doc
				return next "Произошла неизвестная ошибка."
			
			View.message true, 'Продукт успешно сохранен!', res

	], (err) ->
		Logger.log 'info', "Error in controllers/admin/products/save: #{err.message or err}", err
		opts = 
			success: true
			message: "Произошла ошибка при сохранении продукта: #{err.message or err}"

		View.render 'admin/board/message', res, opts

exports.delete = (req, res) ->
	_id = req.params.id
	async.waterfall [
		(next) ->
			Model 'ProductPosition', 'remove', next, p_id: _id
		(affected, results, next) ->
			Model 'Product', 'remove', next, _id: _id
		() ->
			View.message true, 'Продукт успешно удален!', res
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/products/remove: %s #{err.message or err}"
		msg = "Произошла ошибка при удалении продукта: #{err.message or err}"
		View.message false, msg, res