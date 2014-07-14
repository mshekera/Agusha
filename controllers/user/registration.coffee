async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
Mail = require '../../lib/mail'

exports.index = (req, res) ->
	View.renderWithSession req, res, 'user/registration/registration'

exports.register = (req, res) ->
	data = {}
	
	async.waterfall [
		(next) ->
			Model 'Client', 'create', next, req.query
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
		
		Logger.log 'info', "Error in controllers/user/registration: #{error}"
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
				client.type = 1
			
			Model 'Client', 'create', callback, client
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
	
	Logger.log 'info', "Error in controllers/user/registration: #{error}"
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
	
	View.renderWithSession req, res, 'user/registration/success', data