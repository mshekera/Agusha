async = require 'async'

Tour = require '../../models/tour'

View = require '../../lib/view'
Logger = require '../../lib/logger'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			Tour.find next
		(docs) ->
			View.render 'admin/board/tours/index', res, {tours: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/tours/index: %s #{err.message or err}"

exports.get = (req, res) ->
	id = req.params.id
	
	async.waterfall [
		(next) ->
			Tour.findById id, next
		(doc, next) ->
			if doc
				View.render 'admin/board/tours/edit', res, tour: doc
			else
				next "Произошла неизвестная ошибка!"
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/tours/get: %s #{err.message or err}"
		View.message false, err.message or err, res

exports.create = (req, res) ->
	View.render 'admin/board/tours/edit', res, tour: {}

exports.save = (req, res) ->
	_id = req.body.id
	
	data = req.body
	
	async.waterfall [
		(next) ->
			if _id
				Tour.findById _id, next
			else
				next null, null
		(doc, next) ->
			if doc
				for attr of data
					doc[attr] = data[attr]
				
				doc.save next
			else
				Tour.create data, next
		() ->
			View.message true, 'Экскурсия успешно сохранена!', res
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/tours/save: %s #{err.message or err}"
		msg = "Произошла ошибка при сохранении: #{err.message or err}"
		View.message false, msg, res

exports.delete = (req, res) ->
	_id = req.params.id
	
	async.waterfall [
		(next) ->
			Tour.findById _id, next
		(doc, next) ->
			if doc
				doc.remove() #!!!
				View.message true, 'Экскурсия успешно удалена!', res
			else
				next "Произошла неизвестная ошибка."
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/tours/remove: %s #{err.message or err}"
		msg = "Произошла ошибка при удалении: #{err.message or err}"
		View.message false, msg, res