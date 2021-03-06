async = require 'async'
fs = require 'fs'
gm = require('gm').subClass({ imageMagick: true })
path = require 'path'

Logger = require './logger'

uploadsPath = "#{process.cwd()}/public/img/uploads/"

#sizes = [100, 200, 350]
sizes = [160, 220, 420]

exports.doResize = (file) ->
	fns = {}

	for s in sizes
		fns["x#{s}"] = getResizeFn file.name, s

	async.parallel fns, (err) ->
		if err
			console.error "Error occured while resizing image #{file.name}", err
		

exports.doRemoveImage = (imageName, callback) ->
	prefixes = ['']
	for s in sizes
		prefixes.push "x#{s}"

	async.each prefixes, async.apply(removeImage, imageName), callback	

exports.checkDirectories = (callback) ->
	Logger.log 'info', 'Checking image directoires...'
	fns = {}

	for s in sizes
		fns["x#{s}"] = getChkdirFn s

	async.parallel fns, (err, results) ->
		callback err

getResizeFn = (filename, size) ->
	return (callback) ->
		resizeImageTo filename, size, callback

resizeImageTo = (filename, width, callback) ->
	gm(uploadsPath + filename)
		.resize(width)
		.noProfile()
		.write "#{uploadsPath}x#{width}/#{filename}", (err) ->
			filepath = "public/img/uploads/x#{width}/#{filename}"
			if err
				console.log "Error occured while saving file to #{filepath}..."
			else
				console.log "Saved resized file to #{filepath}..."

			callback err, true

removeImage = (imageName, prefix, callback) ->
	imgPath = path.join uploadsPath, prefix, imageName

	async.waterfall [
		(next) ->
			fs.unlink imgPath, next
		() ->
			callback null
	], (err) ->
		if err.code is 'ENOENT'
			response = null
		else
			response = err

		callback response

getChkdirFn = (s) ->
	return (cb) ->
		dirName = "#{uploadsPath}x#{s}"
		fs.mkdir dirName, (err) ->
			unless err
				Logger.log 'info', "%s created...", dirName
				cb null, true
			else if err.code is 'EEXIST'
				Logger.log 'info', "%s already exists...", dirName
				cb null, false
			else
				cb err, true