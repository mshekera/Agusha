async = require 'async'
_ = require 'underscore'
moment = require 'moment'
jade = require 'jade'
fs = require 'fs'
zlib = require 'zlib'
jade = require 'jade'

Logger = require './logger'
Cache = require './cache'
Model = require './model'

string = require '../utils/string'
request = require '../utils/request'

application = require '../init/application'

viewDirectory = "#{__dirname}/../views"

memoizedFuncs = []
compiledClients = []

exports.render = (req, res, path, name, dataFunc, ttl) ->
	result = false
	
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
				if res.locals.is_ajax_request is true
					_.extend data, res.locals
					return ajaxResponse res, null, data
				
				# html = application.ectRenderer.render path += '/index', data
				
				# times = 1000
				# console.time 'jade.compileFile'
				# for i in [1...times]
				
				if not memoizedFuncs[path]?
					options =
						compileDebug: false
						pretty: false
					
					func = jade.compileFile "#{viewDirectory}/#{path}/index.jade", options
					
					memoizedFuncs[path] = _.memoize (data, locals) ->
						newData = _.clone data
						_.extend newData, locals
						
						func newData
					, (data, locals) -> JSON.stringify data
				
				html = memoizedFuncs[path] data, res.locals
				
				# val = loadClient "#{path}/index"
				
				# func = new Function(val.source)();
				
				# html = func data
				
				# console.timeEnd 'jade.compileFile'
				
				# if name
					# ttl = ttl || 0
					
					# Cache.save name, html, ttl, true
				
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

loadClient = (name) ->
	filename = "#{viewDirectory}/#{name}.jade"
	
	# times = 1000
	# console.time 'jade.compileClient'
	# for i in [1...times]
	
	if not compiledClients[name]?
		templateCode = fs.readFileSync filename, "utf-8"
		
		options =
			compileDebug: false
			filename: filename
			pretty: false
		
		compiled = jade.compileClient(templateCode, options).toString()
		
		compiledClients[name] =
			source: "return " + compiled,
			lastModified: (new Date).toUTCString(),
			gzip: null
	
	# console.timeEnd 'jade.compileClient'
	
	compiledClients[name]

exports.compiler = (options) ->
	options = options or {}
	options.root = options.root or "/"
	options.root = "/" + options.root.replace(/^\//, "")
	options.root = options.root.replace(/\/$/, "") + "/"
	rootExp = new RegExp("^" + string.escape(options.root))
	
	(req, res, next) ->
		if req.method isnt "GET" and req.method isnt "HEAD"
			return next()
		
		if not options.root or req.url.substr(0, options.root.length) is options.root
			template = req.url.replace(rootExp, "")
			
			try
				# context = new TemplateContext
				# container = context.load(template)
				
				container = loadClient template
				
				res.setHeader "Content-Type", "application/x-javascript; charset=utf-8"
				res.setHeader "Last-Modified", container.lastModified
				if options.gzip
					res.setHeader "Content-Encoding", "gzip"
					if container.gzip is null
						zlib.gzip container.source, (err, buffer) ->
							unless err
								container.gzip = buffer
								res.end container.gzip
							else
								next err
					else
						res.end container.gzip
				else
					res.setHeader "Content-Length", (if typeof Buffer isnt "undefined" then Buffer.byteLength(container.source, "utf8") else container.source.length)
					res.end container.source
			catch e
				next e
		else
			next()