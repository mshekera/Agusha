async = require 'async'

View = require '../../lib/view'
Auth = require '../../lib/auth'
Logger = require '../../lib/logger'
Mail = require '../../lib/mail'

Client = require '../../models/client'

renderView = (req, res, path, data) ->
	data = data || {}
	
	if req.session.err?
		data.err = req.session.err
		delete req.session.err
	
	View.render path, res, data

exports.index = (req, res) ->
	renderView req, res, 'user/registration/registration'

exports.register = (req, res) ->
	data = {}
	
	async.waterfall [
		(next) ->
			Client.create req.query, next
		(client, next) ->
			data.client = client
			
			options =
				subject: "Успешная регистрация!"
				login: client.login
				email: client.email
			
			Mail.send 'register', options, next
		() ->
			res.redirect '/registration/success/' + data.client._id
	], (err) ->
		error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/registration: %s #{error}"
		req.session.err = error
		res.redirect '/registration'

exports.invite = (req, res) ->
	path = '/registration/success'
	if req.query.invited_by?
		path += '/' + req.query.invited_by
	
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
			res.redirect path
	], (err) ->
		error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/registration: %s #{error}"
		req.session.err = error
		res.redirect path

exports.success = (req, res) ->
	data = {}
	
	if req.params.id?
		data.invited_by = req.params.id
	
	renderView req, res, 'user/registration/success', data