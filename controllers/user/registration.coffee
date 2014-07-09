async = require 'async'

View = require '../../lib/view'
Auth = require '../../lib/auth'
Logger = require '../../lib/logger'

Client = require '../../models/client'

exports.index = (req, res) ->
	data = {}
	
	if req.session.err
		data.err = req.session.err
		delete req.session.err
	
	View.render 'user/registration/registration', res, data

exports.register = (req, res) ->
	console.log req.query
	async.waterfall [
		(next) ->
			Client.create req.query, next
		(client) ->
			console.log client
	], (err) ->
		error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/registration: %s #{error}"
		req.session.err = error
		res.redirect '/registration'