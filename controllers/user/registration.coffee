async = require 'async'

View = require '../../lib/view'
Auth = require '../../lib/auth'
Logger = require '../../lib/logger'
Mail = require '../../lib/mail'

Client = require '../../models/client'

renderView = (req, res, path) ->
	data = {}
	
	if req.session.err?
		data.err = req.session.err
		delete req.session.err
	
	View.render path, res, data

exports.index = (req, res) ->
	renderView req, res, 'user/registration/registration'

exports.register = (req, res) ->
	async.waterfall [
		(next) ->
			Client.create req.query, next
		(client, next) ->
			data =
				subject: "Успешная регистрация!"
				login: client.login
				email: client.email
			
			Mail.send 'register', data, next
		() ->
			res.redirect '/registration/success'
	], (err) ->
		error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/registration: %s #{error}"
		req.session.err = error
		res.redirect '/registration'

exports.invite = (req, res) ->
	async.waterfall [
		(next) ->
			options = req.query
			options.type = 1
			
			Client.create req.query, next
		(client, next) ->
			data =
				subject: "Приглашение!"
				login: client.login
				email: client.email
			
			Mail.send 'invite', data, next
		() ->
			res.redirect '/registration/success'
	], (err) ->
		error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/registration: %s #{error}"
		req.session.err = error
		res.redirect '/registration/success'

exports.success = (req, res) ->
	renderView req, res, 'user/registration/success'