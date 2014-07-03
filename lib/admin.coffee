async = require 'async'
_ = require 'underscore'

View = require './view'

Stat = require '../model/stat'
User = require '../model/user'

metaPage = require '../meta/page'

treeUtil = require '../utils/tree'
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
	res.locals.sidebarMenu = treeUtil.makeTreeObject metaPage

	meta = (treeUtil.findObjectInTree 'href', req.originalUrl, metaPage).pop()

	res.locals.meta = meta

	res.locals.breadcrumbs = meta

	if not meta
		meta = {}
		# error = new Error 'not find Meta description'

		# return View.error error, res

	callback()