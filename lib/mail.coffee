async = require 'async'
nodemailer = require 'nodemailer'
emailTemplates = require 'email-templates'
mail = nodemailer.mail

templatesDir = "#{__dirname}/../views/helpers/email"

exports.send = (name, data, cb) ->
	async.waterfall [
		(next) ->
			emailTemplates "#{templatesDir}", next
		(template, next)->
			template name, data, next
		(html, text, next) ->
			transportOptions =
				host: 'mx1.mirohost.net'
				auth:
					user: 'contact@agusha.com.ua',
					pass: 'aHErkvZu'
			
			transport = nodemailer.createTransport 'SMTP', transportOptions
			
			mailOptions =
				from: "Агуша <contact@agusha.com.ua>",
				to: "#{data.login} <#{data.email}>"
				subject: data.subject
				text: text
				html: html
			console.log 36
			transport.sendMail mailOptions, next
		->
			console.log 37
			cb null
	], (err) ->
		cb err