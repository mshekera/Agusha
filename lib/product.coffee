async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

translit = require '../utils/translit'

exports.makeSearchOptions = (category, age, callback) ->
	searchOptions =
		active: true
	
	async.parallel
		category: (next) ->
			if category
				return Model 'Category', 'findOne', next, {url_label: category}, ''
			
			next null
		age: (next) ->
			if age
				return Model 'Age', 'findOne', next, {level: age}, ''
			
			next null
	, (err, results) ->
		if err
			return callback err
		
		if results.category
			searchOptions.category = results.category._id
		
		if results.age
			searchOptions.age = results.age._id
		
		callback null, searchOptions

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