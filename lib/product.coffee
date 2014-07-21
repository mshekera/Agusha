async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'


exports.addAsyncFunctionsByFilter = (asyncFunctions, data, category, age) ->
	searchOptions = {}
	
	if category
		asyncFunctions = asyncFunctions.concat [
			(next) ->
				Model 'Category', 'findOne', next, {url_label: category}
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
				Model 'Age', 'findOne', next, {level: age}
			(doc, next) ->
				if doc
					searchOptions.age = doc._id
				else
					searchOptions.age = falseObjectID
				next()
		]
	
	asyncFunctions = asyncFunctions.concat [
		(next) ->			
			Model 'Product', 'find', next, searchOptions
		(docs, next) ->			
			Model 'Product', 'populate', next, docs, 'age category'
		(docs, next) ->
			data.products = docs
			
			next()
	]