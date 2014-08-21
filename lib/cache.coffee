fs = require 'fs'
path = require 'path'
async = require 'async'
crypto = require 'crypto'
path = require 'path'
glob = require 'glob'
moment = require 'moment'
jade = require 'jade'
_ = require 'underscore'
cronJob = require('cron').CronJob

Logger = require './logger'

# ###
# 	List of first segment's which will cached
# ###

exports.list = list = [
	{
		segment: '/', 
		name: 'Главная', 
		prefix: 'main_', 
		prefixKey: '' 
	}
	{
		segment: '/unsubscribe', 
		name: 'Отписатся от рассылки', 
		prefix: 'unsubscribe_', 
		prefixKey: 'unsubscribe' 
	}
	{
		segment: '/products', 
		name: 'Продукты', 
		prefix: 'products_', 
		prefixKey: 'products' 
	}
	{
		segments: '/tour'
		name: "Запись на тур"
		prefix: "tour_"
		prefixKey: "tour"
	}
	{
		segments: '/video'
		name: "Видео"
		prefix: "video_"
		prefixKey: "video"
	}
	{
		segment: '/production', 
		name: 'Производство', 
		prefix: 'production_', 
		prefixKey: 'production' 
	}
	{
		segment: '/food', 
		name: 'Питание', 
		prefix: 'food_', 
		prefixKey: 'food' 
	}
	{
		segment: '/news', 
		name: 'Новости', 
		prefix: 'news_', 
		prefixKey: 'news' 
	}
	{
		segment: '/contacts', 
		name: 'Контакты', 
		prefix: 'contacts_', 
		prefixKey: 'contacts' 
	}
	{
		segment: '/feeding_up'
		name: 'Про питание'
		prefix: 'feedingup_'
		prefixKey: 'feeding_up'
	}
	{
		segment: '/product'
		name: 'Продукт'
		prefix: 'product_'
		prefixKey: 'product'
	}
	{
		segment: '/article'
		name: 'Статья'
		prefix: 'article_'
		prefixKey: 'article'
	}
	{
		segment: '/specialist'
		name: 'Статья от специалиста'
		prefix: 'specialist_'
		prefixKey: 'specialist'
	}
	{
		segment: '/signup'
		name: 'Регистрация'
		prefix: 'signup_'
		prefixKey: 'signup'
	}
	{
		segment: '/action'
		name: 'Акция'
		prefix: 'action_'
		prefixKey: 'action'
	}
]


# ###
# 	Relative path to cache directory
# ###

cacheDirectory = "#{__dirname}/../cache"


# ###
# 	Directory of views
# ###

viewDirectory = "#{__dirname}/../views"


# ###
# 	Count of files by list
# ###

exports.cacheCount = (cacheOptions, callback)->
	glob "#{cacheDirectory}/#{cacheOptions.prefix}*", (err, files)->
		cacheOptions.count = files.length

		callback (err||null), (cacheOptions||null)


# ###
# 	Size of cache files by list
# ###

exports.cacheSize = (cacheOptions, callback)->
	async.waterfall [
		(next)->
			cacheOptions.sumSize = 0

			glob "#{cacheDirectory}/#{cacheOptions.prefix}*", (err, files)->
				if err
					return cb null, cacheOptions

				next null, files
		(files, next) ->
			options =
				encoding: 'utf-8'

			async.map files, (file, next2)->
				fs.readFile file, options, next2
			, next
		(filesLengths, next)->
			_.each filesLengths, (item, key, list)->
				cacheOptions.sumSize += item.length

			callback null, cacheOptions
	], callback


# ###
# 	Function which exist segment cache in path
# ###

existSegment = (path)->
	segments = path.split('/')

	segmentPrefix = segments[1] || segments[0]

	segmentList = _.pluck list, 'prefixKey'

	_.contains segmentList, segmentPrefix


# ###
# 	Remove expired files
# ###

removeExpired = (pathToFile, callback)->
	if not pathToFile
		return callback()

	fs.unlink pathToFile, callback

# ###
# 	Check cache file timestamp for putting cache
# ###

checkExpiredPut = (cachename)->
	time = cachename.split('_').pop()
	
	diff = (new Date().getTime())-time
	
	if diff > 3600000
		return cachename
	
	return false

# ###
# 	Check cache file timestamp for request cache
# ###

checkExpiredRequest = (cachename)->
	time = cachename.split('_').pop()

	diff = (new Date().getTime())-time

	if diff < 3600000
		return cachename

	return false

# ###
# 	Getting prefix by path(request or view)
# ###

cacheOptionsByPath = (path, cb)->
	async.waterfall [
		(next)->
			segments = path.split('/')

			if not segments
				return next new Error 'Fail parse Segments of cache'

			segmentPrefix = segments[1] || segments[0]

			return next null, segmentPrefix
		(segmentPrefix, next)->
			objCacheOptions = _.findWhere list, { prefixKey: segmentPrefix }

			if not objCacheOptions
				return cb new Error 'Options of cache not exist'

			cb null, objCacheOptions
	], cb


# ###
# 	Create cache file
# ###

exports.put = (viewPath, viewData, reqPath, globals, callback)->
	if typeof globasl is 'function'
		callback = globals
		globals = {}

	viewData = _.extend viewData, globals

	data = {}

	cacheRegExp = crypto
		.createHash('md5')
		.update(reqPath)
		.digest 'hex'
	
	async.waterfall [
		(next)->
			cacheOptionsByPath reqPath, next
		(options, next)->
			data.options = options

			globString = "#{cacheDirectory}/#{options.prefix}#{cacheRegExp}_*"

			glob globString, next
		(files, next) ->
			expiredFiles = []
			
			filesLength = files.length

			while filesLength--
				file = files[filesLength]

				if checkExpiredPut file
					expiredFiles.push file
			
			async.each expiredFiles, fs.unlink, next 
		(next)->
			jade.renderFile "#{viewDirectory}/#{viewPath}.jade", viewData, next
		(html, next)->
			time = new Date().getTime()
			filename = "#{cacheDirectory}/"+
				"#{data.options.prefix}#{cacheRegExp}_#{time}"

			fs.writeFile filename, html, next
		()->
			callback()
	], callback

###
	Request cachefile
###

exports.requestCache = (req, res, callback)->
	path = req.path
	
	if not existSegment path
		return callback()

	data = {}

	cacheRegExp = crypto
		.createHash('md5')
		.update(path)
		.digest 'hex'

	async.waterfall [
		(next)->
			cacheOptionsByPath path, next
		(options, next)->
			data.options = options

			globString = "#{cacheDirectory}/#{options.prefix}#{cacheRegExp}_*"

			glob globString, next
		(files, next)->
			cacheArr = []
			
			filesLength = files.length
			while filesLength--
				file = files[filesLength]
				if checkExpiredRequest file
					cacheArr.push file
			
			cacheFileName = cacheArr.pop()
			
			if not cacheFileName
				return callback()
			
			optionsReadFile =
				encoding: 'utf-8'
			
			fs.readFile cacheFileName, optionsReadFile, next
		(html, next)->
			res.set 'Content-Type', 'text/html'
			
			res.send html
	], callback

# ###
# 	Remove cache by id
# ###

exports.erease = erase = (id, cb)->
	async.waterfall [
		(next)->
			glob "#{cacheDirectory}/#{id}*", next
		(files, next)->
			async.each files, (file, next2)->
				fs.unlink file, next2
			, next
		(next)->
			cb null
	], cb

exports.cronJob = (next) ->
	new cronJob '0 */6 * * * *', ->
		async.waterfall [
			(next)->
				erase 'signup', next
			() ->
				Logger.log 'info', "Cache cronJob is done"
		], (err) ->
			error = err.message or err
			Logger.log 'info', "Error in lib/cache/cronJob: #{error}"
	, null, true, 'Europe/Kiev'
	
	next null