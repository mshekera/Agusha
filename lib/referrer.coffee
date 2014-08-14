Logger = require '../lib/logger'

exports.isGoodReferrer = (req, res, next)->
	
	referrer = req.header 'Referer'
	
	if referrer
		reg = /:\/\/(.[^/]+)/
		refDomain = referrer.match(reg)[1]
		
		console.log refDomain
		Logger.log 'info', refDomain
	
	next()
