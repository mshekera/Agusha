mongoose = require 'mongoose'
crypto = require 'crypto'

cryptoUtil = require '../../utils/crypto'
validator = require '../../utils/validate'

# AddressModel = require './ss_address'

ObjectId = mongoose.Schema.Types.ObjectId

UserShemaFields = 
	username: { 
		type: String, 
		required: true
		unique: true
	}
	password: {
		type: String, 
		required: true, 
		set: cryptoUtil.password
		validate: validator.password
	}
	role: {
		type: String
		required: true
		default: 0
		ref: 'Role'
	}
	status:
		type: Number
		default: 0
	email: {
		type: String,
		required: true
		unique: true
	}
	created_at:
		type: Number
		default: Date.now
	gender:
		type: Number
		required: true
	firstName:
		type: String
		required: true
	lastName:
		type: String
		required: true
	address: 
		type: ObjectId
		ref: 'Address'

options =
	collection: 'users'

UserShema = new mongoose.Schema UserShemaFields, options

UserShema.methods.validPassword = (password) ->
	md5pass = crypto.createHash('md5').update(password).digest 'hex'

	isValid = if md5pass == @password then true else false

	isValid

UserShema.methods.getUserFlag = ()->
	roles = [
		'notactive'
		'admin'
		'manager'
		'moderator'
		'buyer'
	]

	roles[@role]

UserShema.methods.getRole = ()->
	roles = [
		'Неактивный'
		'Администратор'
		'Менеджер'
		'Модератор'
		'Покупатель'
	]

	roles[@role]

UserShema.methods.getGender = ()->
	genders = [
		'Женский'
		'Мужской'
	]

	genders[@gender]

module.exports =  mongoose.model 'User', UserShema