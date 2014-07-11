async = require 'async'

View = require '../../lib/view'
Logger = require '../../lib/logger'
Model = require '../../lib/model'

exports.index = (req, res) ->
	View.renderWithSession req, res, 'user/excursion/excursion'

exports.add_record = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Tour_record', 'create', next, req.query
		(client, next) ->
			res.redirect '/excursion'
	], (err) ->
		error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/excursion/add_record: %s #{error}"
		req.session.err = error
		res.redirect '/excursion'