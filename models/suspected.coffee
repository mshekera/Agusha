mongoose = require 'mongoose'
autoIncrement = require 'mongoose-auto-increment'

ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed
Validate = require '../utils/validate'
Time = require '../utils/time'

schema = new mongoose.Schema
	date_added:
		type: Date
		default: Date.now
		get: Time.getTimeDateBackwards
	ip_address:
		type: String
		required: true
		validate: Validate.ipAddressIpv4
,
	collection: 'suspected'

opts =
	model: 'Suspected'
	field: 'id'
	startAt: 1

schema.plugin autoIncrement.plugin, opts

module.exports = mongoose.model 'Suspected', schema