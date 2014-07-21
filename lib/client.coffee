async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'
Mail = require './mail'

exports.sendMail = (res, data, callback) ->
	options =
		subject: data.subject
		login: data.client.login
		email: data.client.email
		base_url: res.locals.base_url
	
	if data.salt
		options.salt = data.salt
	
	Mail.send data.template, options, callback