mongoose = require 'mongoose'
ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

schema = new mongoose.Schema
	_id:
		type: ObjectId
		required: true
	name:
		type: String
		required: true
	active:
		type: Boolean
		required: true
,
	collection: 'category'



module.exports = mongoose.model 'Category', schema