mongoose = require 'mongoose'
ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

schema = new mongoose.Schema 
	salt:
		type: String
		required: true
		index: true
	dateCreated:
		type: Date
		default: Date.now
	dateUpdated:
		type: Date
,
	collection: 'salts'

module.exports = mongoose.model 'Salt', schema