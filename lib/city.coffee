async = require 'async'

View = require './view'
Model = require './model'
Logger = require './logger'

select2 = require '../utils/select2'
string = require '../utils/string'

exports.autocomplete = (req, res) ->
	result = []
	
	async.waterfall [
		(next) ->
			str = string.escape req.body.term
			
			findOptions =
				name: new RegExp str, 'i'
			
			Model 'City', 'find', next, findOptions, 'name'
		(docs, next) ->
			docs = select2.convertToSelect2Results docs
			
			res.send docs
	], (err) ->
		console.log err
		res.send err