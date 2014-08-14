Logger = require '../lib/logger'

exports.isGoodReferrer = (req, res, next)->
	
	referrer = req.header 'Referer'
	
	if referrer
		reg = /:\/\/(.[^/]+)/
		refDomain = referrer.match(reg)[1]
		
		console.log referrer
		Logger.log 'info', referrer
	
	next()
