async = require 'async'
_ = require 'underscore'
moment = require 'moment'

Logger = require './logger'
Cache = require './cache'
Model = require './model'

exports.render = render = (name, res, data, cacheId) ->
	data or= {}

	async.parallel [
		(next) -> # cache
			if not cacheId
				return next()

			Cache.put name, data, cacheId, res.locals, next
		(next) -> # view
			res.render name, data
			next()
	], (err, results)->
		if err
			Logger.log 'error', 'Error in View.render:', err

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



exports.globals = (req, res, callback)->
	# async.waterfall [
		# (next)->
			# if not global.menuArticles
				# cbArticles = (err, docs)->
					# if err
						# return Logger.warn err

					# global.menuArticles = docs

					# next()

				# return Model 'Article', 'find', cbArticles, type: 2, 'desc_title'
			# next()
		# (next)->
			# res.locals.topper_menu =
				# food: global.menuArticles || menuArticles
			
			res.locals.defLang = 'ru'
			res.locals.lang = req.lang
			
			if req.user
				res.locals.euser = req.user
				res.locals.user = req.user
			
			res.locals.moment = moment
			
			res.locals.base_url = base_url = 'http://' + req.headers.host
			res.locals.current_url = 'http://' + req.headers.host + req.originalUrl
			res.locals.url = (path) ->
				base_url + path
			
			res.locals.params = req.params
			
			res.locals.strip_tags = (str) ->
				str.replace /<\/?[^>]+>/g, ' '
			
			callback()
	# ], (err)->
		# Logger.warn err
		# callback()

exports.ajaxResponse = (res, err, data) ->
	data =
		err: (if err then err else false)
		data: (if data then data else null)
	
	res.send data
