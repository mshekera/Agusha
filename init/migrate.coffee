async = require 'async'

Model = require '../lib/model'

metaMigrate = require '../meta/migrate'
cities = require '../meta/cities'

checkMigration = (migrate, callback) ->
	async.each migrate.data, (data, next) ->
		Model migrate.modelName, 'findByIdAndUpdate', next, data._id, data, upsert: true
	, callback

addCity = (data, callback) ->
	Model 'City', 'update', callback, data, data, upsert: true

exports.init = (callback) ->
	async.each metaMigrate, checkMigration, callback

exports.init = (callback)->
	console.time 'Info: Migration took'
	async.parallel
		core: (next) ->
			async.each metaMigrate, checkMigration, next
		cities: (next) ->
			async.each cities, addCity, next
	, (err, results) ->
		console.timeEnd 'Info: Migration took'
		
		if err
			console.log err
			callback err
		else
			callback null