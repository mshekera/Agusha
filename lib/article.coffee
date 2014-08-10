async = require 'async'
moment = require 'moment'

View = require './view'
Model = require './model'
Logger = require './logger'

translit = require '../utils/translit'

exports.preformatForUser = preformatForUser = (docs) ->
	result =
		left: []
		right: []
	
	i = 0
	while i < docs.length
		doc = docs[i]
		
		date = moment doc.date
		
		doc.month = date.format 'MMM'
		doc.day = date.format 'DD'
		doc.year = date.format 'YYYY'
		
		if i % 2 == 0
			result.left.push doc
		else
			result.right.push doc
		
		i++
	
	return result

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
			docs = preformatForUser docs
			
			data.articles = docs
			
			View.ajaxResponse res, null, data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in lib/article/findAll: #{error}"
		View.ajaxResponse res, err

exports.makeAliases = (callback) ->
	async.waterfall [
		(next) ->
			Model 'Article', 'find', next
		(docs) ->
			async.each docs, (item, next2) ->
				string = item.desc_title
				
				item.alias = translit string
				
				item.save next2
			, callback
	], callback