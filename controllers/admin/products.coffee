async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
mongoose = require 'mongoose'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Product', 'find', next
		#TODO populate with entities (categories, certificates, ages)
		(docs) ->
			View.render 'admin/board/products/index', res, {products: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/products/index: %s #{err.message or err}"

exports.get = (req, res) ->
	id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Product', 'findOne', next, {id}
		(doc) ->
			Model 'Product', 'populate', next, doc
		(doc) ->
			View.render 'admin/board/products/edit', res, {product: doc}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/products/get: %s #{err.message or err}"

exports.create = (req, res) ->
	View.render 'admin/board/products/edit', res

exports.save = (req, res) ->
	id = req.params.id or mongoose.Types.ObjectId()
	data = req.body
	async.waterfall [
		(next) ->
			Model 'Product', 'update', next, {id}, data, {upsert: true}
		(doc) ->
			opts = 
				success: true
				message: 'Продукт успешно сохранен!'

			View.render 'admin/board/message', res, opts
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/products/save: %s #{err.message or err}"
		opts = 
			success: true
			message: "Произошла ошибка при сохранении продукта: #{err.message or err}"

		View.render 'admin/board/message', res, opts

exports.delete = (req, res) ->