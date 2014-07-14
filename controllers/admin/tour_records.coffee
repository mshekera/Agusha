async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

Tour_record = require '../../lib/tour_record'

exports.index = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Tour_record', 'find', next
		(docs) ->
			View.render 'admin/board/tour_records/index', res, {tour_records: docs}
	], (err) ->
		Logger.log 'info', "Error in lib/tour_record/adminView: #{err.message or err}"