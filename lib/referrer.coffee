Logger = require '../lib/logger'

domainReg = /:\/\/(.[^/]+)/

badDomains = [
	'anti-free.ru'
	'www.anti-free.ru'
	'anonyme.ru'
	'www.anonyme.ru'
	'paradiz.net'
	'www.paradiz.net'
	'pingway.ru'
	'www.pingway.ru'
	'spua.org'
	'www.spua.org'
	'lovipriz.com'
	'www.lovipriz.com'
	'prizolov.ua'
	'www.prizolov.ua'
]

exports.isGoodReferrer = (req, res, next)->
	
	referrer = req.header 'Referer'
	
	if referrer
		refDomain = referrer.match(domainReg)[1]
		
		badDomainsLength = badDomains.length
		while badDomainsLength--
			badDomain = badDomains[badDomainsLength]
			if badDomain == refDomain
				res.send false
				console.log refDomain
				Logger.log 'info', refDomain
	
	next()
