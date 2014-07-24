async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

Tour = require '../../lib/tour'
Tour_record = require '../../lib/tour_record'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'tour'
	
	async.waterfall [
		(next) ->
			findOptions =
				date:
					$gt: new Date()
			
			sortOptions =
				sort:
					date: 1
			
			Model 'Tour', 'find', next, findOptions, {}, sortOptions
		(docs, next) ->
			data.tours = docs
			
			View.renderWithSession req, res, 'user/tour/tour', data
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in lib/tour_record/index: #{error}"
		res.redirect '/'

exports.add_record = (req, res) ->
	async.waterfall [
		(next) ->
			Model 'Tour_record', 'create', next, req.body
		(client, next) ->
			res.redirect '/tour'
	], (err) ->
		error = err.message or err
		
		Logger.log 'info', "Error in lib/tour_record/addRecord: #{error}"
		req.session.err = error
		res.redirect '/tour'