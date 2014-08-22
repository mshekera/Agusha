async = require 'async'
mongoose = require 'mongoose'
moment = require 'moment'
nodeExcel = require 'excel-export'
emailExistence = require 'email-existence'

View = require './view'
Model = require './model'
Logger = require './logger'
Mail = require './mail'

exports.sendMail = sendMail = (res, data, callback) ->
	async.waterfall [
		(next) ->
			emailExistence.check data.client.email, next
		(result) ->
			if result
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
			else
				callback 'There is no such e-mail'
	], callback

exports.signUp = (res, data, post, callback) ->
	info = {}
	
	async.waterfall [
		(next) ->
			post.email = post.email.toLowerCase()
			
			doc = new mongoose.models.Client
			
			for own prop, val of post
				doc[prop] = val
			
			doc.save next
		(client, affected, next) ->
			data.client = client
			
			options = {}
			
			options.template = 'register'
			options.client = client
			options.subject = "Агуша: подтверждение регистрации"
			options.salt = info.salt = new Buffer(client._id.toString()).toString 'base64'
			
			sendMail res, options, (err) ->
				if err
					client.remove next
				else
					next null
		(next) ->
			saltData =
				salt: info.salt
			
			Model 'Salt', 'create', callback, saltData
	], (err) ->
		if data.client
			data.client.remove()
		
		if err.code == 11000
			error = 'Указанный e-mail уже зарегистрирован'
		else
			error = err.message or err
		
		Logger.log 'info', "Error in lib/client/signUp: #{error}"
		
		callback err

exports.exportDocs = (docs, res) ->
	conf = {}

	conf.stylesXmlFile = "#{process.cwd()}/meta/styles.xml"

	conf.cols = [
		{ caption: 'ID', type: 'number' },
		{ caption: 'Логин', type: 'string' },
		{ caption: 'E-m@il', type: 'string' },
		{ caption: 'Дата регистрации', type: 'string' },
		{ caption: 'Дата активации', type: 'string' },
		{ caption: 'Тип', type: 'string' },
		{ caption: 'Приглашение:', type: 'string' },
		{ caption: 'Активен?', type: 'bool' },
		{ caption: 'Подарок', type: 'bool' },
		{ caption: 'Обработан?', type: 'bool' },
		{ caption: 'Имя', type: 'string' },
		{ caption: 'Телефон', type: 'string' },
		{ caption: 'Город', type: 'string' },
		{ caption: 'Улица', type: 'string' },
		{ caption: 'Номер дома', type: 'string' },
		{ caption: 'Квартира', type: 'string' },
		{ caption: 'IP-адрес', type: 'string' }	
	]

	conf.rows = []

	momentFormat = 'HH:mm:ss MM/DD/YYYY'

	for item, index in docs
		conf.rows.push [
			index,
			item.login,
			item.email,
			item.created_at or 'N/A',
			item.activated_at or 'N/A',
			item.type,
			item.invited_by?.login or 'N/A',
			item.active,
			item.status,
			!item.newClient,
			item.fullName() or 'N/A',
			item.phone or 'N/A',
			item.city?.name or 'N/A',
			item.street or 'N/A',
			item.house or 'N/A',
			item.apartment or 'N/A',
			item.ip_address or 'N/A'
		]

	return nodeExcel.execute conf