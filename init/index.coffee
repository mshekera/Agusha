async = require 'async'
_ = require 'underscore'
_.str = require 'underscore.string'

Database = require './database'
Logger = require '../lib/logger'
Migrate = require './migrate'
Application = require './application'
Notifier = require '../lib/notifier'
AuthStartegies = require './auth'

appPort = 80

_.mixin _.str.exports()

async.waterfall [
	(next) ->
		Logger.log 'info', 'Pre initialization succeeded'
		Logger.init next
	(next) ->
		Logger.log 'info', 'Logger is initializated'

		Migrate.init next
	(next) ->
		Logger.log 'info', 'Migrate is initializated'

		Application.init next
	(next) ->
		Logger.log 'info', "Application is initializated"

		AuthStartegies.init next
	(next) ->
		Logger.log 'info', 'Auth is initializated'

		Notifier.init Application.server, next
	(next) ->
		Logger.log 'info', 'Notifier is initializated'

		Application.listen appPort, next
	(next)->
		Logger.log 'info', "Application is binded to #{appPort}"
], (err)->
	Logger.error 'Init error: ', err