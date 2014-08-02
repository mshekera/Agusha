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
			
			View.renderWithSession req, res, 'user/tour/tour', data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/tour/index: #{error}"
		res.redirect '/'

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
	
	asyncFunctions = [
		(next) ->
			Model 'Tour_record', 'create', next, data
		(client, next) ->
			req.session.message = 'В ближайшее время на ваш e-mail<br />придет письмо с подробными инструкциями.'
			req.session.messageLabel = 'Поздравляем, вы записаны на экскурсию!'
			
			next()
	]
	
	if req.body.signup
		signUpData =
			login: data.firstname + ' ' + data.lastname
			email: data.email
		
		asyncFunctions = asyncFunctions.concat Client.addAsyncFunctionsForSignUp res, {}, signUpData
	
	asyncFunctions.push (next) ->
		res.redirect '/tour'
	
	async.waterfall asyncFunctions, (err) ->
		Logger.log 'info', "Error in controllers/user/tour/add_record: #{err}"
		req.session.err = err
		res.redirect '/tour'