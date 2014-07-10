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
	
	async.map req.query.client, (client, callback) ->
		if client.login and client.email
			if req.query.invited_by?
				client.invited_by = req.query.invited_by
			
			Client.create client, callback
		else
			callback null
	, (err, clients) ->
		if err
			inviteErr err, req
			return res.redirect path
		
		async.map clients, sendInviteMail, (err, result) ->
			if err
				inviteErr err, req
				
			res.redirect path

inviteErr = (err, req) ->
	error = err.message or err
	
	Logger.log 'info', "Error in controllers/user/registration: %s #{error}"
	req.session.err = error

sendInviteMail = (client, callback) ->
	if client
		options =
			subject: "Успешная регистрация!"
			login: client.login
			email: client.email
		
		Mail.send 'register', options, callback
	else
		callback null

exports.success = (req, res) ->
	data = {}
	
	if req.params.id?
		data.invited_by = req.params.id
	
	renderView req, res, 'user/registration/success', data