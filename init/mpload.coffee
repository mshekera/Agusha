exports.init = (next) ->
	require '../models/age'
	require '../models/article'
	require '../models/client'
	require '../models/product'
	require '../models/tour'
	require '../models/tour_record'

	next()