async = require 'async'
_ = require 'underscore'

View = require './view'

Stat = require '../models/stat'
User = require '../models/user'

timeUtil = require '../utils/time'

exports.index = (callback)->
	query =
		created_on:
			$gt: timeUtil.startOf 'week', 0
			$lt: timeUtil.startOf 'week', 6

	async.parallel
		WebStat: (next) ->
			Stat.find(query)
				.exec next
		User: (next)->
			User.find(query)
				.exec next
	, callback


exports.locals = (req, res, callback)->
	callback()