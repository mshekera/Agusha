mongoose = require 'mongoose'
ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

schema = new mongoose.Schema 
	title:
		type: String
		required: true
	text:
		type: String
	image:
		type: String
	storage_life:
		type: Number
		required: true
	storage_conditions:
		type: String
	composition:
		type: String
	volume:
		type: Number
	active:
		type: Boolean
		required: true
		default: false
	recommended:
		type: String
	age:
		type: ObjectId
		ref: "Age"
		required: true
	certificate: [
		type: ObjectId
		ref: "Certificate"
	]
	category: [
		type: ObjectId
		ref: "Category"
	]
	age_level:
		type: Number
	main_page:
		type: Number
		default: 0
,
	collection: 'product'

module.exports = mongoose.model 'Product', schema