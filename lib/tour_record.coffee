async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

exports.adminView = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Tour_record', 'find', next
		(docs) ->
			View.render 'admin/board/tour_records/index', res, {tour_records: docs}
	], (err) ->
		Logger.log 'info', "Error in controllers/admin/tour_records/index: %s #{err.message or err}"