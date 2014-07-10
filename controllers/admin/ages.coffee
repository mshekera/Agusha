async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
mongoose = require 'mongoose'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Age', 'find', next
		(docs) ->
			View.render 'admin/board/ages/index', res, {ages: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/ages/index: %s #{err.message or err}"

exports.get = (req, res) ->
	id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Age', 'findOne', next, _id: id
		(doc, next) ->
			if doc
				View.render 'admin/board/ages/edit', res, age: doc
			else
				next "Произошла неизвестная ошибка!"
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/ages/get: %s #{err.message or err}"
		View.message false, err.message or err, res

exports.create = (req, res) ->
	View.render 'admin/board/ages/edit', res,
		age: {}

exports.save = (req, res) ->
	_id = req.body.id or mongoose.Types.ObjectId()

	data = req.body
	data.icon = req.files?.icon?.name or ""
	data.desc_image = req.files?.desc_image?.name or ""

	async.waterfall [
		(next) ->
			Model 'Age', 'update', next, {_id}, data, {upsert: true}
		(doc, next) ->
			if doc
				View.message true, 'Возраст успешно сохранен!', res
			else
				next "Произошла неизвестная ошибка."
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/ages/save: %s #{err.message or err}"
		msg = "Произошла ошибка при сохранении возраста: #{err.message or err}"
		View.message false, msg, res

exports.delete = (req, res) ->
	_id = req.params.id
	async.waterfall [
		(next) ->
			Model 'Age', 'findOne', next, {_id}
		(doc, next) ->
			if doc
				doc.remove() #!!!
				View.message true, 'Возраст успешно удален!', res
			else
				next "Произошла неизвестная ошибка."
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/ages/remove: %s #{err.message or err}"
		msg = "Произошла ошибка при удалении возраста: #{err.message or err}"
		View.message false, msg, res