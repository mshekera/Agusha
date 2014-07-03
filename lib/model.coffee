mongoose = require 'mongoose'

exports.find = (query, fields, modelName, cb) ->
	unless typeof cb is 'function'
		cb = modelName
		modelName = fields
		fields = null

	unless typeof cb is 'function'
		throw new Error 'No callback provided to `Model` library `find` function'

	mdl = require "../models/#{modelName}"

	if fields
		mdl.find query, fields, cb
	else
		mdl.find query, cb

exports.findOne = (query, fields, modelName, cb) ->

exports.count = (query, modelName, cb) ->

exports.create = (query, modelName, cb) ->

exports.update = (query, modelName, cb) ->

exports.populate = (query, modelName, cb) ->