mongoose = require 'mongoose'
moment = require 'moment'

ObjectId = mongoose.Schema.Types.ObjectId
Mixed = mongoose.Schema.Types.Mixed

timeUtil = require '../utils/time'

getArticleType = (type) ->
	switch type
		when 0 then msg = "Новости"
		when 1 then msg = "Акции"
		when 2 then msg = "Кормление"
		when 3 then msg = "От специалиста"
		else throw new Error "Incorrect type index in Article model: #{type}"

	return {
		id: type
		msg: msg
	}

schema = new mongoose.Schema
	type: # 0 - news, 1 - sales, 2 - feeding, 3 - from spec
		type: Number
		required: true
		get: getArticleType
	date:
		type: Date
		get: timeUtil.getDate
		set: timeUtil.setDate
	image:
		type: String
	innerImage:
		type: String
	desc_image: [
		type: String
	]
	desc_image_link:
		type: String
	desc_title:
		type: String
		required: true
		unique: true
	button_label:
		type: String
	big_title:
		type: String
	desc_shorttext:
		type: String
	desc_text:
		type: String
	active:
		type: Boolean
		required: true
		default: true
	alias:
		type: String
		index: true
	shared_text:
		type: String
,
	collection: 'article'

schema.static 'findArticles', (cb) ->
	where = 
		"$or": [
			{type: 2}
			{type: 3}
		]
	@find where, cb

schema.static 'findNews', (active, cb) ->
	findOptions =
		$or: [
			{type: 0}
			{type: 1}
		]
	
	if active == true
		findOptions.active = active
	
	sortOptions =
		lean: true
		sort:
			date: -1
	
	@find findOptions, {}, sortOptions, cb

module.exports = mongoose.model 'Article', schema