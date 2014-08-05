async = require 'async'
fs = require 'fs'
gm = require('gm').subClass({ imageMagick: true })

path = "#{process.cwd()}/public/img/uploads/"

handleError = (err) ->
	console.log '------------------'
	console.log err
	console.log '------------------'

init = () ->
	async.waterfall [
		(next) ->
			fs.readdir path, next
		processImages
		() ->
			console.log 'Script completed work!'

	], handleError

processImages = (files, next) ->
	async.eachSeries files, checkImage, next

checkImage = (filename, callback) ->
	async.waterfall [
		(next) ->
			fs.stat path + filename, next
		(stat, next) ->
			unless stat.isFile()
				return callback()

			next null, filename
		resizeImage
		() ->
			callback null
	], (err) ->
		if err
			handleError err
		else
			callback null

resizeImage = (filename, next) ->
	async.parallel
		x100: (callback) ->
			resizeImageTo filename, 100, callback
		x200: (callback) ->
			resizeImageTo filename, 200, callback
		x350: (callback) ->
			resizeImageTo filename, 350, callback
	, (err) ->
		next err

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

			callback null, true

init()