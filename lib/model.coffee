mongoose = require 'mongoose'
sprintf = require('sprintf').sprintf

noModel = 'Exception in Model library: model with name %s does not exist'
noMethod = 'Exception in Model library: method with name %s does not exist'

module.exports = (modelName, methodName, cb, args...) ->
	mdl = mongoose.models[modelName]

	throw new Error sprintf noModel, modelName if mdl is undefined

	method = mdl[methodName]

	throw new Error sprintf noMethod, methodName if method is undefined

	method.apply(mdl, args).exec cb