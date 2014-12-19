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
winners = require '../../meta/winners'

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

exports.registerGet = (req, res) ->
	data = {}
	
	signUpData = req.params
	signUpData.ip_address = req.connection.remoteAddress
	signUpData.login = string.title_case req.params.email
	
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

inviteMail = (res, client, friendDoc, callback) ->
	data = {}
	
	async.waterfall [
		(next) ->
			friend = null
			
			options =
				template: 'invite'
				client: client
			
			if friendDoc
				options.friend = friend = friendDoc.login								
			
			options.subject = 'Ваш друг ' + friend + ' приглашает вас в сообщество Агуша'
			options.salt = data.salt = new Buffer(client._id.toString()).toString 'base64'
			
			Client.sendMail res, options, (err) ->
				if err
					return client.remove callback
				
				next null
		(next) ->
			saltData =
				salt: data.salt
			
			Model 'Salt', 'create', callback, saltData
	], callback

inviteMakeClient = (invited_by, already_invited, client, callback) ->
	async.waterfall [
		(next) ->
			client.email = client.email.toLowerCase()
			client.login = string.title_case client.login
			
			Model 'Client', 'findOne', next, email: client.email
		(doc) ->
			if doc
				already_invited.push client
				return callback null
			
			if !(client.login and client.email)
				return callback null
			
			if invited_by?
				client.invited_by = invited_by
				client.type = 1
			
			doc = new mongoose.models.Client
			
			for own prop, val of client
				doc[prop] = val
			
			doc.save callback
	], callback

exports.invite = (req, res) ->
	invited_by = req.body.invited_by
	
	already_invited = []
	
	async.map req.body.client, (client, callback) ->
		inviteMakeClient invited_by, already_invited, client, callback
	, (err, clients) ->
		if err
			return inviteErr err, res
		
		async.waterfall [
			(next) ->
				Model 'Client', 'findById', next, invited_by
			(doc, next) ->
				async.map clients, (client, callback) ->
					if !client
						return callback null
					
					inviteMail res, client, doc, callback
				, next
			(result) ->
				data = {}
				
				if already_invited.length
					data.already_invited = already_invited
				
				View.ajaxResponse res, null, data
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
			Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"
			return res.send error
		
		# data.client = results.client
		
		# View.render 'user/signup/activate/activate', res, data, req.path
		
		res.redirect '/signup/success/' + results.client._id

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

# exports.win = (req, res) ->
	# email = req.params.email
	
	# if !email?
		# return async.mapSeries winners.slice(480, 501), (winner, next) ->
			# options =
				# template: 'win'
				# client:
					# login: winner.login
					# email: winner.email
					# number: winner.number
				# subject: "Ваш подарок от Агуши"
			# console.log options
			# Client.sendMail res, options, next
		# , (err, result) ->
			# if err
				# return res.send err
			
			# res.send true
	
	# options =
		# template: 'win'
		# client:
			# login: email
			# email: email
		# subject: "Ваш подарок от Агуши"
	
	# Client.sendMail res, options, (err) ->
		# if err
			# return res.send err
		
		# res.send true

exports.letter_so_zlakami = (req, res) ->
	email = req.params.email
	
	if !email?
		limit = 5000
		
		sortOptions =
			lean: true
			skip: 1158
			limit: limit
		
		return async.waterfall [
			(next) ->
				Model 'Client', 'find', next, null, 'email login', sortOptions
			(docs, next) ->
				async.timesSeries limit, (n, next2) ->
					doc = docs[n]
					
					options =
						template: 'so_zlakami'
						client:
							login: string.toTitleCase doc.login
							email: doc.email
							n: n
						
						subject: "Агуша // Злакова лінійка"
					console.log options
					Client.sendMail res, options, next2
				, next
		], (err, result) ->
			if err
				return res.send err
			
			res.send true
		
		async.mapSeries winners.slice(0, 0), (winner, next) ->
			options =
				template: 'so_zlakami'
				client:
					login: winner.login
					email: winner.email
					number: winner.number
				
				subject: "Агуша // Злакова лінійка"
			console.log options
			Client.sendMail res, options, next
		, (err, result) ->
			if err
				return res.send err
			
			res.send true
	
	options =
		template: 'so_zlakami'
		client:
			login: email
			email: email
		
		subject: "Агуша // Злакова лінійка"
	
	Client.sendMail res, options, (err) ->
		if err
			return res.send err
		
		res.send true