async = require 'async'
moment = require 'moment'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
		# Why sort it if datatable resorting it by login after initialization?
		#	options =
		#		sort:
		#			date: -1
			
			Model 'Client', 'find', next#, {}, {}, options
		(docs, next) ->
			Model 'Client', 'populate', next, docs, 'invited_by city'
		(docs) ->
			View.render 'admin/board/clients/index', res, {clients: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/clients/index: #{err.message or err}"

exports.process = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Client', 'findOne', next, _id: req.body.id.replace /"/g, ''
		(doc, next) ->
			unless doc
				return res.send 'Нет клиента с таким ID.'

			if doc.newClient
				doc.newClient = false
				doc.save next
			else
				res.send result: 0
		(doc) ->
			res.send result: if doc.newClient then -1 else 1

	], (err) ->
		res.send err.message or err

exports.remove = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Client', 'findOne', next, _id: req.body.id.replace /"/g, ''
		(doc, next) ->
			unless doc
				return next "Такого пользователя (уже) нет в системе."

			doc.remove next
		(doc) ->
			res.send result: true
	], (err) ->
		res.send result: err.message or err

exports.setStatus = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Client', 'findOne', next, _id: req.body.id.replace /"/g, ''
		(doc, next) ->
			unless doc
				return next "Такого пользователя (уже) нет в системе."

			doc.status = req.body.status
			doc.save next
		(doc, affected) ->
			res.send result: if affected then true else false
	], (err) ->
		res.send result: err.message or err

exports.export = (req, res) ->
	field = req.body.type
	range = req.body.range.split ' - '
	from = moment range[0], 'DD/MM/YYYY HH:mm'
	to = moment range[1], 'DD/MM/YYYY HH:mm'

	async.waterfall [
		(next) ->
			where = {}
			where[field] =
				$gte: from.valueOf()
				$lt: to.valueOf()

			Model 'Client', 'find', next, where
		(docs, next) ->
			Model 'Client', 'populate', next, docs, 'invited_by city'
		(docs) ->
			result = Client.exportDocs docs, res
			res.setHeader 'Content-Type', 'application/vnd.openxmlformats'
			res.setHeader "Content-Disposition", "attachment; filename=Clients.xlsx"
			res.end result, 'binary'
	], (err) ->

