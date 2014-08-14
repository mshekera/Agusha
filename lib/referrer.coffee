Logger = require '../lib/logger'

exports.isGoodReferrer = (req, res, next)->
	referrer = req.header 'Referer'
	console.log referrer
	Logger.log 'info', referrer
	
	next()
