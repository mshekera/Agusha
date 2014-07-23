mongoose = require 'mongoose'

ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

schema = new mongoose.Schema
	id:
		type: Number
		required: true
		index: true
	name:
		type: String
		required: true
		index: true
,
	collection: 'city'

module.exports = mongoose.model 'City', schema