async = require 'async'
_ = require 'underscore'
mongoose = require 'mongoose'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

tree = require '../../utils/tree'
string = require '../../utils/string'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	if req.cookies.registered
		return res.redirect '/signup/success/' + req.cookies.registered
	
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'signup'
	
	View.render 'user/signup/signup', res, data, req.path

exports.registered = (req, res) ->
	if req.cookies.registered
		return res.redirect '/signup/success/' + req.cookies.registered
	
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'signup'
		message: true
	
	View.render 'user/signup/signup', res, data, req.path

exports.register = (req, res) ->
	data = {}
	
	signUpData = req.body
	signUpData.ip_address = req.connection.remoteAddress
	signUpData.login = string.title_case signUpData.login
	
	async.waterfall [
		(next) ->
			Client.signUp res, data, signUpData, next
		(salt) ->
			req.session.message = true
			View.ajaxResponse res
	], (err) ->
		if err.code == 11000
			error = 'Указанный e-mail уже зарегистрирован'
		else
			error = err.message or err
		
		Logger.log 'info', "Error in controllers/user/signup/register: #{error}"
		View.ajaxResponse res, error

exports.invite = (req, res) ->
	invited_by = req.body.invited_by
	
	already_invited = []
	
	async.map req.body.client, (client, callback) ->
		async.waterfall [
			(next) ->
				client.email = client.email.toLowerCase()
				client.login = string.title_case client.login
				
				Model 'Client', 'findOne', next, email: client.email
			(doc) ->
				if doc
					already_invited.push client
					return callback null
				
				if client.login and client.email
					if invited_by?
						client.invited_by = invited_by
						client.type = 1
					
					doc = new mongoose.models.Client
					
					for own prop, val of client
						doc[prop] = val
					
					doc.save callback
					
					# Model 'Client', 'create', callback, client
				else
					callback null
		], callback
	, (err, clients) ->
		if err
			inviteErr err, res
		
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
								
								Client.sendMail res, options, (err) ->
									if err
										client.remove callback
									else
										next2 null
							(next2) ->
								saltData =
									salt: data.salt
								
								Model 'Salt', 'create', callback, saltData
						], callback
					else
						callback null
				, next
			(result) ->
				err = null
				data = {}
				
				if already_invited.length
					data.already_invited = already_invited
				
				View.ajaxResponse res, err, data
		], (err) ->
			inviteErr err, res

inviteErr = (err, res) ->
	if err.code == 11000
		error = 'Указанный e-mail уже зарегистрирован'
	else
		error = err.message or err
	
	Logger.log 'info', "Error in controllers/user/signup/invite: #{error}"
	View.ajaxResponse res, error

exports.success = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'signup'
	
	if req.params.id?
		data.invited_by = req.params.id
	
	View.render 'user/signup/success/success', res, data, req.path

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
			Model 'Salt', 'findOneAndUpdate', next, salt: salt, {dateUpdated: Date.now()}
	, (err, results) ->
		if err
			error = err.message or err
			return Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
		
		data.client = results.client
		
		View.render 'user/signup/activate/activate', res, data, req.path

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
			data.ip_address = req.connection.remoteAddress
			data.activated_at = new Date()
			data.status = true
			data.firstName = string.title_case data.firstName
			data.lastName = string.title_case data.lastName
			data.patronymic = string.title_case data.patronymic
			
			Model 'Client', 'findByIdAndUpdate', next, id, data
		(doc, next) ->
			if not doc
				error = 'Такого пользователя не существует, кто-то пытается жульничать.'
				Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
				return View.ajaxResponse res, error
			
			client = doc
			
			res.cookie('registered', doc._id);
			
			options =
				template: 'activate'
				client: doc
				subject: "Ваш подарок от Агуши"
			
			Client.sendMail res, options, next
		() ->
			data =
				id: client._id
			
			View.ajaxResponse res, null, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
		View.ajaxResponse res, error