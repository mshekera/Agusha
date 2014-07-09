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
			Model 'Age', 'findOne', next, {id}
		(doc) ->
			Model 'Age', 'populate', next, doc
		(doc) ->
			View.render 'admin/board/ages/edit', res, {age: doc}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/ages/get: %s #{err.message or err}"

exports.create = (req, res) ->
	View.render 'admin/board/ages/edit', res

exports.save = (req, res) ->
	id = req.params.id or mongoose.Types.ObjectId()
	data = req.body
	async.waterfall [
		(next) ->
			Model 'Age', 'update', next, {id}, data, {upsert: true}
		(doc) ->
			opts = 
				success: true
				message: 'Возраст успешно сохранен!'

			View.render 'admin/board/message', res, opts
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/ages/save: %s #{err.message or err}"
		opts = 
			success: true
			message: "Произошла ошибка при сохранении возраста: #{err.message or err}"

		View.render 'admin/board/message', res, opts

exports.delete = (req, res) ->