mongoose = require 'mongoose'
ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

schema = new mongoose.Schema 
	title:
		type: String
		required: true
	text:
		type: String
		required: false
	image:
		type: String
		required: false
	storage_life:
		type: Number
		required: true
	composition:
		type: Array
		required: false
	volume:
		type: Number
		required: true
	active:
		type: Boolean
		required: true
	age_id:
		type: ObjectId
		required: true
	age_level:
		type: Number
		required: true
,
	collection: 'product'



module.exports = mongoose.model 'Product', schema
