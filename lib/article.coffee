async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

exports.findAll = (req, res) ->
	type = req.body.type
	
	data = {}
	
	searchOptions =
		active: true
	
	if type
		searchOptions.type = type
	else
		searchOptions.$or = [
			{type: 0}
			{type: 1}
		]
	
	sortOptions =
		sort:
			date: -1
	
	async.waterfall [
		(next) ->
			Model 'Article', 'find', next, searchOptions, {}, sortOptions
		(docs) ->
			data.articles = docs
			
			View.ajaxResponse res, null, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in lib/article/findAll: #{error}"
		View.ajaxResponse res, err