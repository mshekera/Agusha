Logger = require '../lib/logger'

exports.isGoodReferrer = (req, res, next)->
	referrer = req.header 'Referer'
	Logger.log 'info', referrer
	
	next()
