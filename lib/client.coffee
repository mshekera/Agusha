async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'
Mail = require './mail'

exports.sendMail = sendMail = (res, data, callback) ->
	options =
		subject: data.subject
		login: data.client.login
		email: data.client.email
		base_url: res.locals.base_url
	
	if data.salt
		options.salt = data.salt
	
	if data.friend
		options.friend = data.friend
	
	Mail.send data.template, options, callback

exports.addAsyncFunctionsForSignUp = (res, data, post) ->
	info = {}
	
	return asyncFunctions = [
		(next) ->
			Model 'Client', 'create', next, post
		(client, next) ->
			data.client = client
			
			options = {}
			
			options.template = 'register'
			options.client = client
			options.subject = "Успешная регистрация!"
			options.salt = info.salt = new Buffer(client._id.toString()).toString 'base64'
			
			sendMail res, options, next
		(next) ->
			saltData =
				salt: info.salt
			
			Model 'Salt', 'create', next, saltData
	]