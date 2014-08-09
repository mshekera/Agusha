async = require 'async'
_ = require 'underscore'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	if req.cookies.registered
		return res.redirect '/signup/success/' + req.cookies.registered
	
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
	
	invited_by = req.body.invited_by
	
	if invited_by?
		path += '/' + invited_by
	
	already_invited = []
	
	async.map req.body.client, (client, callback) ->
		async.waterfall [
			(next) ->
				Model 'Client', 'findOne', next, email: client.email
			(doc) ->
				if doc
					already_invited.push client
					return callback null
				
				if client.login and client.email
					if invited_by?
						client.invited_by = invited_by
						client.type = 1
					
					Model 'Client', 'create', callback, client
				else
					callback null
		], callback
	, (err, clients) ->
		if err
			inviteErr err, req
			return res.redirect path
		
		async.waterfall [
			(next) ->
				Model 'Client', 'findById', next, invited_by
			(doc, next) ->
				async.map clients, (client, callback) ->
					if client
						data = {}
						
						async.waterfall [
							(next2) ->
								friend = null
								
								options =
									template: 'invite'
									client: client
								
								if doc
									options.friend = friend = doc.login								
								
								options.subject = 'Ваш друг ' + friend + ' приглашает вас в сообщество Агуша'
								options.salt = data.salt = new Buffer(client._id.toString()).toString 'base64'
								
								Client.sendMail res, options, next2
							(next2) ->
								saltData =
									salt: data.salt
								
								Model 'Salt', 'create', callback, saltData
						], callback
					else
						callback null
				, next
			(result) ->
				alreadyInvitedLength = already_invited.length
				if alreadyInvitedLength
					req.session.err = ''
					
					while alreadyInvitedLength--
						client = already_invited[alreadyInvitedLength]
						req.session.err += '<div>' + client.login + ' уже приглашен. Попробуйте пригласить еще кого-нибудь.</div>'
				
				req.session.message = 'ТЕПЕРЬ ВАШИ ДРУЗЬЯ БУДУТ В КУРСЕ ВСЕГО САМОГО ПОЛЕЗНОГО И ИНТЕРЕСНОГО.'
				req.session.messageLabel = 'Спасибо!'
				res.redirect path
		], (err) ->
			inviteErr err, req

inviteErr = (err, req) ->
	if err.code == 11000
		error = 'Указанный e-mail уже зарегистрирован'
	else
		error = err.message or err
	
	Logger.log 'info', "Error in controllers/user/signup/invite: #{error}"
	return req.session.err = error

exports.success = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'signup'
	
	if req.params.id?
		data.invited_by = req.params.id
	
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
	
	client = {}
	
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
		(doc, next) ->
			if not doc
				error = 'Такого пользователя не существует, кто-то пытается жульничать.'
				Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
				return res.redirect '/signup'
			
			client = doc
			
			res.cookie('registered', doc._id);
			
			options =
				template: 'activate'
				client: doc
				subject: "Ваш подарок от Агуши"
			
			Client.sendMail res, options, next
		() ->
			res.redirect '/signup/success/' + client._id
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
		req.session.err = error
		res.redirect '/signup/activate/' + salt