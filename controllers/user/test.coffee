async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

stringUtil = require '../../utils/string'

sendTestEmail = (res, email, callback) ->
	async.waterfall [
		(next) ->
			Model 'Client', 'count', next
		(count, next) ->
			skip = Math.floor Math.random() * count
			
			sortOptions =
				skip: skip
				lean: true
			
			Model 'Client', 'findOne', next, type: 0, 'login email password_real', sortOptions
		(doc) ->
			options =
				client:
					login: stringUtil.title_case doc.login
					email: doc.email
					password: doc.password_real
					_id: doc._id
				email: email
				subject: 'Приглашаем на обновленный сайт для современных родителей!'
				template: 'new_password'
			
			console.log doc
			
			Client.sendMail res, options, callback
	], callback

exports.email = (req, res) ->
	# email = 'hydraorc@gmail.com'
	emails = [
		'dkirpa@gmail.com'
		'zmorbohdan@gmail.com'
		# 'andrew.sygyda@gmail.com'
		# 'yuriy.kabay@outlook.com'
		# 'max.shekera@gmail.com'
		# 'kasyanov.mark@gmail.com'
		'hydraorc@gmail.com'
		'hydra0@bigmir.net'
		# 'imhereintheshadows@gmail.com'
		'v.nechayenko@peppermint.com.ua'
		't.shvydenko@peppermint.com.ua'
		'i.kozh@peppermint.com.ua'
		'e.vysotsky@peppermint.com.ua'
	]
	
	async.eachSeries emails, (email, callback) ->
		sendTestEmail res, email, callback
	, (err) ->
		if err
			error = err.message or err
			Logger.log 'info', "Error in controllers/user/test/sendTestEmail: #{error}"
			return res.send error
		
		res.send true

send_new = (res, doc, callback) ->
	options =
		client:
			login: stringUtil.title_case doc.login
			email: doc.email
			password: doc.password_real
			_id: doc._id
		email: doc.email
		subject: 'Приглашаем на обновленный сайт для современных родителей!'
		template: 'new_password'
	
	console.log doc
	
	Client.sendMail res, options, callback

exports.send_new_passwords = (req, res) ->
	options =
		$or: [
			email:
				$ne: 'natashenka1992@mail.ru'
		,
			email:
				$ne: 'aleksandra_govor@mail.ru'
		,
			email:
				$ne: 'xaecka90@mail.ru'
		,
			email:
				$ne: 'makarenko2504@rambler.ru'
		,
			email:
				$ne: 'deneshzka@mail.ru'
		,
			email:
				$ne: 'valernat@gmail.com'
		,
			email:
				$ne: 'davidenko_@i.ua'
		,
			email:
				$ne: 'murinkav@mail.ru'
		,
			email:
				$ne: 'andrew.sygyda@gmail.com'
		,
			email:
				$ne: 'vanya.kostyuk.93@mail.ru'
		,
			email:
				$ne: 'kravchenkoanechka@yandex.ru'
		,
			email:
				$ne: 'seninkasper@gmail.com'
		,
			email:
				$ne: 'pusyxa@i.ua'
		,
			email:
				$ne: 'tetyanka_ne@mail.ru'
		,
			email:
				$ne: 'ylka-a_aleynik@mail.ru'
		,
			email:
				$ne: 'ligurina@ukr.net'
		,
			email:
				$ne: 'dimao2014@inbox.ru'
		,
			email:
				$ne: 'lesyaberd@mail.ru'
		,
			email:
				$ne: 'iracvik@rambler.ru'
		,
			email:
				$ne: 'frendnastya@mail.ru'
		,
			email:
				$ne: 'alesya8508@mail.ru'
		,
			email:
				$ne: 'demenko_lyudmila@mail.ru'
		,
			email:
				$ne: 'yan-bondarenk@yandex.ru'
		,
			email:
				$ne: 'raselo4ek@rambler.ru'
		,
			email:
				$ne: 'inna_cher@mail.ru'
		,
			email:
				$ne: 'max.shekera@gmail.com'
		,
			email:
				$ne: 'vitaliya7777@gmail.com'
		,
			email:
				$ne: 'Liliya-04.02@inbox.ru'
		,
			email:
				$ne: 'Croxmal@yandex.ru'
		]
	
	async.waterfall [
		(next) ->
			Model 'Client', 'find', next, options
		(docs, next) ->
			console.log docs.length
			
			async.timesSeries docs.length, (n, next2) ->
				console.log n
				doc = docs[n]
				
				send_new res, doc, next2
			, next
		(results) ->
			console.log 'send_new_passwords done'
			res.send true
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/test/send_new_passwords: #{error}"

make_passwords = (doc, callback) ->
	randomstring = Math.random().toString(36).slice(-8)
	
	doc.password = doc.password_real = randomstring
	
	doc.save callback

exports.generate_passwords = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Client', 'find', next
		(docs, next) ->
			async.each docs, make_passwords, next
		(results) ->
			res.send true
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/test/generate_passwords: #{error}"
		res.send error

exports.client_findAll = (req, res) ->
	result = []
	
	async.waterfall [
		(next) ->
			fields = 'created_at activated_at login email type invited_by firstName patronymic lastName phone city postIndex street house apartment ip_address password_real'
			
			Model 'Client', 'find', next, null, fields, lean: true
		(docs, next) ->
			Model 'Client', 'populate', next, docs, 'city'
		(docs, next) ->
			docsLength = docs.length
			while docsLength--
				doc = docs[docsLength]
				newDoc =
					created_at: doc.created_at
					activated_at: doc.activated_at
					login: stringUtil.title_case doc.login
					email: doc.email
					type: doc.type
					invited_by: doc.invited_by
					invited_by: doc.invited_by
					active: true
					profile:
						first_name: stringUtil.title_case doc.firstName
						last_name: stringUtil.title_case doc.lastName
						middle_name: stringUtil.title_case doc.patronymic
					contacts:
						phone: doc.phone
						city: (if doc.city then doc.city.name else '')
						postIndex: doc.postIndex
						street: stringUtil.title_case doc.street
						houseNum: doc.house
						apartament: doc.apartment
					ip_address: doc.ip_address
					password: doc.password_real
					_id: doc._id
				
				result.push newDoc
				
			res.send result
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/test/client_findAll: #{error}"
		res.send error

exports.client_mailChimp = (req, res) ->
	result = []
	
	async.waterfall [
		(next) ->
			fields = 'login email firstName lastName -_id'
			
			sortOptions =
				lean: true
				skip: 0
				limit: 1990
			
			Model 'Client', 'find', next, null, fields, sortOptions
		(docs, next) ->
			Model 'Client', 'populate', next, docs, 'city'
		(docs, next) ->
			docsLength = docs.length
			while docsLength--
				doc = docs[docsLength]
				newDoc =
					'Login': stringUtil.title_case doc.login
					'Email Address': doc.email.toLocaleLowerCase()
					'First Name': stringUtil.title_case doc.firstName
					'Last Name': stringUtil.title_case doc.lastName
				
				result.push newDoc
			
			res.send result
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/test/client_findAll: #{error}"
		res.send error