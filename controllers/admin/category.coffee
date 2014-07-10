async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
mongoose = require 'mongoose'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Category', 'find', next
		(docs) ->
			View.render 'admin/board/category/index', res, {categories: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/category/index: %s #{err.message or err}"

exports.get = (req, res) ->
	id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Category', 'findOne', next, _id: id
		(doc, next) ->
			if doc
				View.render 'admin/board/category/edit', res, category: doc
			else
				next "Произошла неизвестная ошибка!"
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/category/get: %s #{err.message or err}"
		View.message false, err.message or err, res

exports.create = (req, res) ->
	View.render 'admin/board/category/edit', res,
		category: {}

exports.save = (req, res) ->
	_id = req.body.id

	data = req.body
	delete data._wysihtml5_mode if data._wysihtml5_mode

	async.waterfall [
		(next) ->
			if _id
				async.waterfall [
					(next2) ->
						Model 'Category', 'findOne', next2, {_id}
					(doc) ->
						for own prop, val of data
							unless prop is 'id' or val is undefined
								doc[prop] = val

						doc.active = data.active or false

						doc.save next
				], (err) ->
					next err
			else
				Model 'Category', 'create', next, data
		(doc, next) ->
			if doc
				View.message true, 'Категория успешно сохранена!', res
			else
				next "Произошла неизвестная ошибка."
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/category/save: %s #{err.message or err}"
		msg = "Произошла ошибка при сохранении: #{err.message or err}"
		View.message false, msg, res

exports.delete = (req, res) ->
	_id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Category', 'findOne', next, {_id}
		(doc, next) ->
			if doc
				doc.remove() #!!!
				View.message true, 'Категория успешно удалена!', res
			else
				next "Произошла неизвестная ошибка."
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/category/remove: %s #{err.message or err}"
		msg = "Произошла ошибка при удалении: #{err.message or err}"
		View.message false, msg, res