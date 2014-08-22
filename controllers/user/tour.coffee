async = require 'async'
_ = require 'underscore'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Tour = require '../../lib/tour'
Client = require '../../lib/client'
Tour_record = require '../../lib/tour_record'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'tour'
	
	async.waterfall [
		(next) ->
			findOptions =
				date:
					$gt: new Date()
			
			sortOptions =
				sort:
					date: 1
			
			Model 'Tour', 'find', next, findOptions, {}, sortOptions
		(docs, next) ->
			data.tours = docs
			
			View.render 'user/tour/tour', res, data, req.path
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/tour/index: #{error}"
		res.redirect '/'

signUp = (data, callback) ->
	signUpData =
		login: data.firstname + ' ' + data.lastname
		email: data.email
	
	async.waterfall [
		(next) ->
			Model 'Client', 'findOne', next, email: data.email
		(doc) ->
			if !doc?
				return Client.signUp res, {}, signUpData, callback
			
			callback null
	], callback

exports.add_record = (req, res) ->
	fields = [
		'firstname'
		'lastname'
		'patronymic'
		'tour'
		'email'
		'phone'
		'city'
	]
	
	data = _.pick req.body, fields
	data.children = []
	
	childrenLength = req.body.children.length
	while childrenLength--
		child = req.body.children[childrenLength]
		if !child.name.length || (child.age == '__ месяцев' || !child.age.length)
			continue
		child.age = parseInt child.age
		data.children.push child
	
	async.waterfall [
		(next) ->
			Model 'Tour_record', 'create', next, data
		(doc, next) ->
			# req.session.message = 'В ближайшее время на ваш e-mail<br />придет письмо с подробными инструкциями.'
			# req.session.messageLabel = 'Поздравляем, вы записаны на экскурсию!'
			
			# req.session.message = 'Дождитесь следующей экскурсии!'
			# req.session.messageLabel = 'Ой, все места заняты!'
			
			next()
		(next) ->
			if req.body.signup
				return signUp data, next
			
			next null
		(next) ->
			View.ajaxResponse res
	], (err) ->
		error = error.message || err
		Logger.log 'info', "Error in controllers/user/tour/add_record: #{error}"
		View.ajaxResponse res, error