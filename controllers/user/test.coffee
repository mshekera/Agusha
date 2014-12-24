async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Client = require '../../lib/client'

stringUtil = require '../../utils/string'

make_passwords = (email, callback) ->
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
					email: email
					password: doc.password_real
				
				subject: 'Агуша - обновленный сайт'
				template: 'new_password'
			
			console.log doc
			
			Client.sendMail res, options, (err, html) ->
				if err
					return res.send err
				
				callback null
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/test/generate_passwords: #{error}"
		res.send error

exports.email = (req, res) ->
	# email = 'hydraorc@gmail.com'
	emails = [
		'dkirpa@gmail.com'
		'zmorbohdan@gmail.com'
		'andrew.sygyda@gmail.com'
		'yuriy.kabay@outlook.com'
		'max.shekera@gmail.com'
		'kasyanov.mark@gmail.com'
		'hydra0@bigmir.net'
	]
	
	async.eachSeries emails, sendTestEmail, (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/test/sendTestEmail: #{error}"
		res.send error

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