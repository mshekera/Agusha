# require('look').start 1007, '109.74.0.77'
async = require 'async'
_ = require 'underscore'
_.str = require 'underscore.string'
moment = require 'moment'

Database = require './database'
Migrate = require './migrate'
Application = require './application'
AuthStartegies = require './auth'
ModelPreloader = require './mpload'

Logger = require '../lib/logger'
Image = require '../lib/image'
Product = require '../lib/product'
Article = require '../lib/article'
Cache = require '../lib/cache'

process.setMaxListeners 0

appPort = 1337

_.mixin _.str.exports()

moment.lang 'ru'

async.waterfall [
	(next) ->
		Logger.log 'info', 'Pre initialization succeeded'
		Logger.init next
	(next) ->
		Logger.log 'info', 'Logger is initializated'
		
		ModelPreloader "#{process.cwd()}/models/", next
	(next) ->
		Logger.log 'info', 'Models are preloaded'
		
		Migrate.init next
	(next) ->
		Logger.log 'info', 'Migrate is initializated'

		Image.checkDirectories next
	(next) ->
		Logger.log 'info', 'Image directories are checked'
		
		Product.makeAliases next
	(next) ->
		Logger.log 'info', 'Product aliases are recreated'
		
		Article.makeAliases next
	(next) ->
		Logger.log 'info', 'Article aliases are recreated'
		
		Application.init next
	(next) ->
		Logger.log 'info', "Application is initializated"
		
		AuthStartegies.init next
	(next) ->
		Logger.log 'info', 'Auth is initializated'
		
		Application.listen appPort, next
	(next) ->
		Logger.log 'info', "Application is binded to #{appPort}"
		
		Cache.cronJob next
	(next) ->
		Logger.log 'info', "Cache cronJob is started"
], (err) ->
	error = err.message || err
	Logger.error 'Init error: ', error