async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Tour = require '../../lib/tour'
Tour_record = require '../../lib/tour_record'

exports.index = (req, res) ->
	View.renderWithSession req, res, 'user/tour/tour'

exports.add_record = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Tour_record', 'create', next, req.body
		(client, next) ->
			res.redirect '/tour'
	], (err) ->
		error = err.message or err
		
		Logger.log 'info', "Error in lib/tour_record/addRecord: #{error}"
		req.session.err = error
		res.redirect '/tour'