async = require 'async'
_ = require 'underscore'
moment = require 'moment'
jade = require 'jade'
fs = require 'fs'

Logger = require './logger'
Cache = require './cache'
Model = require './model'

string = require '../utils/string'
request = require '../utils/request'

application = require '../init/application'

viewDirectory = "#{__dirname}/../views"

exports.render = (req, res, path, name, dataFunc, ttl) ->
	result = false
	
	is_ajax_request = res.locals.is_ajax_request
	
	if is_ajax_request is true
		path += '/content'
	else
		path += '/index'
	
	if(name && typeof(name) == 'function')
		dataFunc = name
		name = false
	
	# if name
		# result = Cache.get 'file', name # get your cached view
	
	if !result
		return async.waterfall [
			(next) ->
				if(dataFunc && typeof(dataFunc) == 'function')
					return dataFunc req, res, next
				
				next null, {}
			(data) ->
				data = _.extend data, res.locals
				
				html = application.ectRenderer.render path, data
				
				# if name
					# ttl = ttl || 0
					
					# Cache.save name, html, ttl, true
				
				if is_ajax_request is true
					options =
						data: data
						html: html
					
					return ajaxResponse res, null, options
				
				res.send html
		], (err) ->
			error = err.message || err
			Logger.log 'error', 'Error in View.render: ', error + ''
			res.send error
	
	res.send result

# exports.render = render = (req, res, name, data, cacheId) ->
	# data or= {}
	
	# is_ajax_request = request.is_ajax_request(req.headers)
	
	# if is_ajax_request is true
		# name += '/content'
	# else
		# name += '/index'
	
	# async.parallel [
		# (next) -> # cache
			# if not cacheId
				# return next()

			# Cache.put name, data, cacheId, res.locals, next
		# (next) -> # view
			# if is_ajax_request is true
				# data = _.extend data, res.locals
				
				# html = jade.render fs.readFileSync("#{viewDirectory}/#{name}.jade", 'utf8'), data
				
				# options =
					# data: data.data
					# html: html
				
				# return ajaxResponse res, null, options
			
			# res.render name, data
			# next()
	# ], (err, results)->
		# if err
			# Logger.log 'error', 'Error in View.render:', err + ''

exports.renderWithSession = (req, res, path, data) ->
	data = data || {}

	if req.session.err?
		data.err = req.session.err
		delete req.session.err
	else if req.session.message?
		data.messageLabel = req.session.messageLabel || null
		data.message = req.session.message
		delete req.session.messageLabel
		delete req.session.message
	
	render path, res, data, req.path

exports.message = message = (success, message, res) ->
	data = {
		success
		message
	}

	render 'admin/board/message', res, data

exports.error = (err, res) ->
	message false, err.message or err, res

exports.clientError = (err, res) ->
	data =
		success: false
		error: err.message
		code: err.code

	render 'user/main/error/index', res, data

exports.clientSuccess = (data, res)->
	data =
		success: true
		message: data

	res.send data

exports.clientFail = (err, res)->
	res.status 500

	data =
		success: false
		message: err

	res.send data

baseurl = (url)->
	func = (path)->
		url+path

exports.globals = (req, res, callback)->
	res.locals.defLang = 'ru'
	res.locals.lang = req.lang
	
	if req.user
		res.locals.euser = req.user
		res.locals.user = req.user
	
	res.locals.moment = moment
	
	res.locals.base_url = base_url = 'http://' + req.headers.host
	res.locals.current_url = 'http://' + req.headers.host + req.originalUrl
	res.locals.url = baseurl base_url
	
	res.locals.params = req.params
	
	res.locals.strip_tags = string.strip_tags
	
	res.locals.is_ajax_request = request.is_ajax_request(req.headers)
	
	res.locals.basedir = __dirname 
	
	callback()

exports.ajaxResponse = ajaxResponse = (res, err, data) ->
	data =
		err: (if err then err else false)
		data: (if data then data else null)
	
	res.send data
