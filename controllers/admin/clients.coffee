async = require 'async'
moment = require 'moment'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

index = (req, res, callback) ->
	limit = req.body.limit || 100
	page = req.body.page || 1
	skip = (page - 1) * limit
	searchString = req.body.string

	clients = []
	count = 0
	async.waterfall [
		(next) ->
			options =
				sort:
					date: -1

			search = {}

			if searchString
				searchRegExp = new RegExp '.*' + searchString + '.*', 'g'
				search =
					$or: [
						{ firstName: searchRegExp }
						{ patronymic: searchRegExp }
						{ lastName: searchRegExp }
						{ email: searchRegExp }
						{ login: searchRegExp }
					]

			Model('Client', 'find', null, search, {}, options)
				.skip(skip)
				.limit(limit)
				.exec next
		(docs, next) ->
			Model 'Client', 'populate', next, docs, 'invited_by city'
		(docs, next) ->
			clients = docs
			Model 'Client', 'count', next
		(count) ->
			callback null, [clients, docs.length || count, page, limit]
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/clients/index: #{err.message or err}"
		return err

exports.index = (req, res) ->
	index req, res, (err, data) ->
		return View.message false, err.message or err, res if err

		[clients, count, page, limit] = data

		View.render 'admin/board/clients/index', res, {clients, count, page, limit}

exports.reindex = (req, res) ->
	index req, res, (err, data) ->
		return View.message false, err.message or err, res if err

		[clients, count, page, limit] = data

		res.send {clients, count, page, limit}

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