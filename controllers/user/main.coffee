async = require 'async'
moment = require 'moment'
_ = require 'underscore'

View = require '../../lib/view'
Auth = require '../../lib/auth'

time = require '../../utils/time'

gallery = require '../../meta/gallery'

exports.index = (req, res) ->
	currentDate = moment()
	endDate = moment '20.11.2014', 'DD/MM/YYYY'
	diffInDays = endDate.diff currentDate, 'days'
	
	data =
		gallery: gallery
		daysArray: _.chars diffInDays+''
		declension: time.declension diffInDays
	
	View.render 'user/index', res, data