async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

select2 = require '../utils/select2'

exports.autocomplete = (req, res) ->
	result = []
	
	async.waterfall [
		(next) ->
			findOptions =
				name: new RegExp req.body.term, 'i'
			
			Model 'City', 'find', next, findOptions
		(docs, next) ->
			async.each docs, (data, next2) ->
				select2.convertToSelect2Results result, data, next2
			, next
		->
			res.send result
	], (err) ->
		console.log err
		res.send err