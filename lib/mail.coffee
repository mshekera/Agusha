async = require 'async'
nodemailer = require 'nodemailer'
emailTemplates = require 'email-templates'
mail = nodemailer.mail

templatesDir = "#{__dirname}/../views/helpers/email"

transportOptions =
	service: "Gmail"
	auth:
		user: "nodesmtp@gmail.com",
		pass: "smtpisverygood11"

# transportOptions =
	# host: 'smtp.mandrillapp.com'
	# auth:
		# user: 'hydra0@bigmir.net',
		# pass: 'rgfp2YbrNJ9KkQiAimvRmg'

# transportOptions =
	# host: '0.0.0.0'
	# port: '25'
	# auth:
		# user: 'root'
		# pass: ''

# transportOptions =
	# host: 's02.atomsmtp.com'
	# port: '2525'
	# auth:
		# user: 'contact@agusha.com.ua'
		# pass: 'DeNgYYmNeAp2ScK'

exports.send = (name, data, cb) ->
	result = ''
	
	async.waterfall [
		(next) ->
			emailTemplates "#{templatesDir}", next
		(template, next)->
			template name, data, next
		(html, text, next) ->
			result = html
			
			transport = nodemailer.createTransport 'SMTP', transportOptions
			
			mailOptions =
				from: "Агуша <contact@agusha.com.ua>",
				to: "#{data.client.login} <#{data.client.email}>"
				subject: data.subject
				text: text
				html: html
			
			transport.sendMail mailOptions, next
		->
			cb null, result
	], (err) ->
		cb err