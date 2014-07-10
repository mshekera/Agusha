async = require 'async'

View = require '../../lib/view'
Client = require '../../models/client'
Logger = require '../../lib/logger'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			Client.find().sort({date: 'desc'}).exec next
		(docs) ->
			View.render 'admin/board/clients/index', res, {clients: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/clients/index: %s #{err.message or err}"