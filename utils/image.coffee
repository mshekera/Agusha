async = require 'async'
fs = require 'fs'
gm = require('gm').subClass({ imageMagick: true })

path = "#{process.cwd()}/public/img/uploads/"

exports.doResize = (file) ->
	async.parallel
		x100: (callback) ->
			resizeImageTo file.name, 100, callback
		x200: (callback) ->
			resizeImageTo file.name, 200, callback
		x350: (callback) ->
			resizeImageTo file.name, 350, callback
	, (err) ->
		if err
			console.error "Error occured while resizing image #{file.name}", err
		

resizeImageTo = (filename, width, callback) ->
	gm(path + filename)
		.resize(width)
		.noProfile()
		.write "#{path}x#{width}/#{filename}", (err) ->
			filepath = "public/img/uploads/x#{width}/#{filename}"
			if err
				console.log "Error occured while saving file to #{filepath}..."
			else
				console.log "Saved resized file to #{filepath}..."

			callback err, true