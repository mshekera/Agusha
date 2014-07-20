async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'
Mail = require './mail'

exports.sendMail = (data, callback) ->
	options =
		subject: data.subject
		login: data.client.login
		email: data.client.email
	
	if data.salt
		options.salt = data.salt
	
	Mail.send data.template, options, callback