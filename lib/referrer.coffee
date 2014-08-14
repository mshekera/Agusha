mongoose = require 'mongoose'

View = require './view'
Model = require './model'
Logger = require './logger'

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

exports.isGoodReferrer = (req, res, callback)->
	
	referrer = req.header 'Referer'
	
	if referrer
		refDomain = referrer.match(domainReg)[1]
		
		ip = req.connection.remoteAddress
		
		async.waterfall [
			(next) ->
				Model 'Suspected', findOne, next, ip_address: ip
			(doc) ->
				if !doc
					badDomainsLength = badDomains.length
					while badDomainsLength--
						badDomain = badDomains[badDomainsLength]
						if badDomain == refDomain
							data =
								ip_address: ip
							
							doc = new mongoose.models.Suspected
							doc.ip_address = ip
							
							return doc.save callback
					
					return callback()
				
				return res.send false
		], callback
	
	callback()