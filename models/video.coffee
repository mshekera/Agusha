mongoose = require 'mongoose'
ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

Time = require '../utils/time'

schema = new mongoose.Schema 
	id:
		type: String
		required: true
		unique: true
	title:
		type: String
		required: true
	published:
		type: Date
		required: true
		get: Time.getDate
,
	collection: 'video'

module.exports = mongoose.model 'Video', schema