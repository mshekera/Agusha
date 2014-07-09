mongoose = require 'mongoose'

ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed
Validate = require '../utils/validate'

schema = new mongoose.Schema
	_id:
		type: ObjectId
	created_at:
		type: Date
	login:
		type: String
		required: true
	email:
		type: String
		required: true
		trim: true
		match: Validate.email
	type: # 0 - direct, 1 - friend
		type: Number
	invited_by:
		type: ObjectId
		ref: 'Client'
,
	collection: 'client'

module.exports = mongoose.model 'Client', schema