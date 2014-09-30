async = require 'async'
moment = require 'moment'
_ = require 'underscore'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

time = require '../../utils/time'

gallery = require '../../meta/gallery'

setData = () ->
	currentDate = moment()
	endDate = moment '15.10.2014', 'DD/MM/YYYY'
	diffInDays = endDate.diff currentDate, 'days'
	
	data =
		gallery: gallery
		daysArray: _.chars diffInDays+''
		declension: time.declension diffInDays

exports.index = (req, res) ->
	data = setData()
	
	View.render 'user/index', res, data, req.path
	
	# async.waterfall [
		# (next) ->
			# findOptions =
				# main_page:
					# '$ne': 0
			
			# sortOptions =
				# sort:
					# main_page: 1
				# limit: 3
			
			# Model 'Product', 'find', next, findOptions, {}, sortOptions
		# (docs, next) ->
			# Model 'Product', 'populate', next, docs, 'category'
		# (docs) ->
			# data.mainPageProducts = docs
			
			# View.render 'user/index', res, data, req.path
	# ], (err) ->
		# error = err.message or err
		# Logger.log 'info', "Error in controllers/user/main/index: #{error}"
		# res.send error

exports.unsubscribe = (req, res) ->
	data = setData()
	data.unsubscribe = true
	
	View.render 'user/index', res, data, req.path
	
	# res.redirect '/'
	# res.redirect '/'