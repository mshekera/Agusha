Logger = require '../lib/logger'

exports.isGoodReferrer = (req, res, next)->
	referrer = req.headers.referrer || req.headers.referer
	Logger.log 'info', referrer
	
	next()
