mongoose = require 'mongoose'

ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

schema = new mongoose.Schema
	_id:
		type: ObjectId
		required: true
	date:
		type: Date
		required: true
,
	collection: 'tour'

module.exports = mongoose.model 'Tour', schema