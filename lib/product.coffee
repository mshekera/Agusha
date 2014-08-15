async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

translit = require '../utils/translit'

falseObjectID = '111111111111111111111111'

exports.addAsyncFunctionsByFilter = (data, category, age) ->
	searchOptions =
		active: true
	
	asyncFunctions = []
	
	if category
		asyncFunctions = asyncFunctions.concat [
			(next) ->
				Model 'Category', 'findOne', next, {url_label: category}, ''
			(doc, next) ->
				if doc
					searchOptions.category = doc._id
				else
					searchOptions.category = falseObjectID
				next()
		]
	
	if age
		asyncFunctions = asyncFunctions.concat [
			(next) ->
				Model 'Age', 'findOne', next, {level: age}, ''
			(doc, next) ->
				if doc
					searchOptions.age = doc._id
				else
					searchOptions.age = falseObjectID
				next()
		]
	
	return asyncFunctions = asyncFunctions.concat [
		(next) ->
			Model 'Product', 'find', next, searchOptions
		(docs, next) ->
			Model 'Product', 'populate', next, docs, 'age category'
		(docs, next) ->
			data.products = docs
			
			next()
	]

exports.getAgesAndCategories = (callback) ->
	async.parallel {
		ages: (next) ->
			options =
				sort:
					level: 1
			
			Model 'Age', 'find', next, {active: true}, {}, options
		categories: (next) ->
			Model 'Category', 'find', next, {active: true}
	}, callback

exports.makeAliases = (callback) ->
	async.waterfall [
		(next) ->
			Model 'Product', 'find', next
		(docs) ->
			async.each docs, (item, next2) ->
				volume = item.getFormattedVolume()
				string = item.title + ' ' + volume.volume + ' ' + volume.postfix
				string = string.replace(RegExp(' +(?= )', 'g'), '') # remove double spaces
				string = string.toLowerCase()
				
				item.alias = translit string
				
				item.save next2
			, callback
	], callback