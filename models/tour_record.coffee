mongoose = require 'mongoose'

ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed
Validate = require '../utils/validate'

schema = new mongoose.Schema
	date:
		type: Date
		required: false
	firstname:
		type: Array
		required: false
	lastname:
		type: String
		required: true
	patronymic:
		type: String
		required: false
	email:
		type: String
		required: false
		match: Validate.email
	phone:
		type: String
		required: false
	city:
		type: String
		required: false
	children: [
		name: String
		gender: Boolean
		age: Number
		withParents: Boolean
	]
	active:
		type: Boolean
		required: true
		default: false
	is_read:
		type: Boolean
		required: true
		default: false
	tour_id:
		type: ObjectId
		ref: 'Tour'
,
	collection: 'tour_record'



module.exports = mongoose.model 'Tour_record', schema
