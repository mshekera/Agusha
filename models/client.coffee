mongoose = require 'mongoose'
autoIncrement = require 'mongoose-auto-increment'

ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed
Validate = require '../utils/validate'
Time = require '../utils/time'

getType = (val) ->
	switch val
		when 0
			return 'Direct'
		when 1
			return 'Friend'

schema = new mongoose.Schema
	created_at:
		type: Date
		default: Date.now
		get: Time.getTimeDateBackwards
	activated_at:
		type: Date
		get: Time.getTimeDateBackwards
	login:
		type: String
		required: true
	email:
		type: String
		required: true
		trim: true
		unique: true
		index: true
		validate: Validate.email
	type: # 0 - direct, 1 - friend
		type: Number
		default: 0
		get: getType
	invited_by:
		type: ObjectId
		ref: 'Client'
	active:
		type: Boolean
		default: false
	hasKids: # 0 - does not have, 1 - has, 2 - is waiting
		type: Number
	firstName:
		type: String
	patronymic:
		type: String
	lastName:
		type: String
	phone:
		type: String
	city:
		type: ObjectId
		ref: 'City'
	postIndex:
		type: String
	street:
		type: String
	house:
		type: String
	apartment:
		type: String
	newClient:
		type: Boolean
		default: true
	status:
		type: Boolean
		default: false
	ip_address:
		type: String
		validate: Validate.ipAddressIpv4
	password:
		type: String
	password_real:
		type: String
,
	collection: 'client'

schema.methods.fullName = () ->
	[@lastName, @firstName, @patronymic].join ' '

module.exports = mongoose.model 'Client', schema
