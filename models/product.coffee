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
		required: false
	age_level:
		type: Number
		required: false
,
	collection: 'product'



module.exports = mongoose.model 'Product', schema
