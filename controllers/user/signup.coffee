async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'signup'
	
	View.renderWithSession req, res, 'user/signup/signup', data

exports.register = (req, res) ->
	data = {}
	
	asyncFunctions = Client.addAsyncFunctionsForSignUp res, data, req.body
	
	asyncFunctions = asyncFunctions.concat [
		(salt) ->
			res.redirect '/signup/success/' + data.client._id
	]
	
	async.waterfall asyncFunctions, (err) ->
		if err.code == 11000
			error = 'Указанный e-mail уже зарегистрирован'
		else
			error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/signup/register: #{error}"
		req.session.err = error
		res.redirect '/signup'

exports.invite = (req, res) ->
	path = '/signup/success'
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
		
		async.map clients, (client, callback) ->
			if client
				data = {}
				
				async.waterfall [
					(next) ->
						options =
							template: 'invite'
							client: client
							subject: "Успешная регистрация по приглашению!"
						
						options.salt = data.salt = new Buffer(client._id.toString()).toString 'base64'
						
						Client.sendMail res, options, next
					(next) ->
						saltData =
							salt: data.salt
						
						Model 'Salt', 'create', callback, saltData
				], callback
			else
				callback null
		, (err, result) ->
			if err
				inviteErr err, req
				
			res.redirect path

inviteErr = (err, req) ->
	if err.code == 11000
		error = 'Указанный e-mail уже зарегистрирован'
	else
		error = err.message or err
	
	Logger.log 'info', "Error in controllers/user/signup/invite: #{error}"
	req.session.err = error

exports.success = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'signup'
	
	if req.params.id?
		data.invited_by = req.params.id
		
		if not req.session.err
			data.messageLabel = 'Спасибо за регистрацию!'
			data.message = 'В ближашее время на ваш e-mail придет письмо<br />с подтверждением.'
	
	View.renderWithSession req, res, 'user/signup/success/success', data

exports.activate = (req, res) ->
	id = new Buffer(req.params.salt, 'base64').toString 'utf8'
	
	async.parallel
		client: (next) ->
			Model 'Client', 'findByIdAndUpdate', next, id, active: true
		salt: (next) ->
			Model 'Salt', 'findOneAndUpdate', next, {salt: req.params.salt}, {dateUpdated: Date.now()}
	, (err, results) ->
		if err
			error = err.message or err
			Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
		else if not results.client
			Logger.log 'info', "Error in controllers/user/signup/activate: 'There is no such user'"
			res.redirect '/signup/success/'
		else
			res.redirect '/signup/success/' + results.client._id