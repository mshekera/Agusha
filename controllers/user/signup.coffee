async = require 'async'
_ = require 'underscore'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'signup'
	
	if req.session.message
		data.message = true
		delete req.session.message
	
	View.renderWithSession req, res, 'user/signup/signup', data, req.path

exports.register = (req, res) ->
	data = {}
	
	asyncFunctions = Client.addAsyncFunctionsForSignUp res, data, req.body
	
	asyncFunctions = asyncFunctions.concat [
		(salt) ->
			req.session.message = true
			res.redirect '/signup'
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
	
	View.renderWithSession req, res, 'user/signup/success/success', data, req.path

exports.activate = (req, res) ->
	salt = req.params.salt
	
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'activate'
		salt: salt
		
	id = new Buffer(salt, 'base64').toString 'utf8'
	
	async.parallel
		client: (next) ->
			Model 'Client', 'findByIdAndUpdate', next, id, active: 1
		salt: (next) ->
			Model 'Salt', 'findOneAndUpdate', next, {salt: req.params.salt}, {dateUpdated: Date.now()}
	, (err, results) ->
		if err
			error = err.message or err
			return Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
		
		data.client = results.client
		
		View.renderWithSession req, res, 'user/signup/activate/activate', data, req.path

exports.activatePost = (req, res) ->
	salt = req.body.salt
	
	id = new Buffer(salt, 'base64').toString 'utf8'
	
	async.waterfall [
		(next) ->
			fields = [
				'hasKids'
				'firstName'
				'city'
				'lastName'
				'postIndex'
				'patronymic'
				'street'
				'phone'
				'house'
				'apartment'
			]
			data = _.pick req.body, fields
			
			Model 'Client', 'findByIdAndUpdate', next, id, data
		(doc) ->
			if not doc
				error = 'Такого пользователя не существует, кто-то пытается жульничать.'
				Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
				return res.redirect '/signup'
			
			res.redirect '/signup/success/' + doc._id
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
		req.session.err = error
		res.redirect '/signup/activate/' + salt