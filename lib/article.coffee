async = require 'async'
moment = require 'moment'

View = require './view'
Model = require './model'
Logger = require './logger'

exports.preformatDate = preformatDate = (docs) ->
	docsLength = docs.length
	while docsLength--
		doc = docs[docsLength]
		
		date = moment doc.date
		
		doc.month = date.format 'MMM'
		doc.day = date.format 'DD'
		doc.year = date.format 'YYYY'
	
	return docs

exports.findAll = (req, res) ->
	type = req.body.type
	
	data = {}
	
	searchOptions =
		active: true
	
	if type? && type != ''
		searchOptions.type = type
	else
		searchOptions.$or = [
			{type: 0}
			{type: 1}
		]
	
	sortOptions =
		lean: true
		sort:
			date: -1
	
	async.waterfall [
		(next) ->
			Model 'Article', 'find', next, searchOptions, {}, sortOptions
		(docs) ->
			docs = preformatDate docs
			
			data.articles = docs
			
			View.ajaxResponse res, null, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in lib/article/findAll: #{error}"
		View.ajaxResponse res, err