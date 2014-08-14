exports.isGoodReferrer = (req, res, next)->
	referrer = req.headers.referrer || req.headers.referer
	console.log referrer
	Logger.log 'info', 'referrer'
	
	next()
