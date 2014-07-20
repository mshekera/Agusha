async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'registration'
	
	View.renderWithSession req, res, 'user/registration/registration', data

exports.register = (req, res) ->
	data = {}
	
	async.waterfall [
		(next) ->
			Model 'Client', 'create', next, req.body
		(client, next) ->
			data.client = client
			subject = "Успешная регистрация!"
			
			Client.sendMail client, 'register', subject, next
		() ->
			res.redirect '/registration/success/' + data.client._id
	], (err) ->
		if err.code == 11000
			error = 'Указанный e-mail уже зарегистрирован'
		else
			error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/registration: #{error}"
		req.session.err = error
		res.redirect '/registration'

exports.invite = (req, res) ->
	path = '/registration/success'
	if req.body.invited_by?
		path += '/' + req.body.invited_by
	
	async.map req.body.client, (client, callback) ->
		if client.login and client.email
			if req.body.invited_by?
				client.invited_by = req.body.invited_by
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
	if err.code == 11000
		error = 'Указанный e-mail уже зарегистрирован'
	else
		error = err.message or err
	
	Logger.log 'info', "Error in controllers/user/registration: #{error}"
	req.session.err = error

sendInviteMail = (client, callback) ->
	if client
		subject = "Успешная регистрация по приглашению!"
		
		Client.sendMail client, 'invite', subject, callback
	else
		callback null

exports.success = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'registration'
	
	if req.params.id?
		data.invited_by = req.params.id
	
	if not req.session.err
		data.messageLabel = 'Спасибо за регистрацию!'
		data.message = 'В ближашее время на ваш e-mail придет письмо<br />с подтверждением.'
	
	View.renderWithSession req, res, 'user/registration/success/success', data