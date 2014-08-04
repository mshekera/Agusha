mongoose = require 'mongoose'
ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

schema = new mongoose.Schema 
	id:
		type: String
		required: true
		unique: true
	title:
		type: String
		required: true
,
	collection: 'video'

module.exports = mongoose.model 'Video', schema