mongoose = require 'mongoose'
async = require 'async'

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
	ip = req.connection.remoteAddress
	
	async.waterfall [
		(next) ->
			Model 'Suspected', 'findOne', next, ip_address: ip
		(doc, next) ->
			if !doc # client is not suspected yet, check him
				if referrer
					refDomain = referrer.match(domainReg)[1]
					
					badDomainsLength = badDomains.length
					while badDomainsLength--
						badDomain = badDomains[badDomainsLength]
						if badDomain == refDomain # client came from one of bad domains, block him		
							newDoc = new mongoose.models.Suspected
							newDoc.ip_address = ip
							
							return newDoc.save next
				
				return callback() # client is clean
			
			return res.send false # client is suspected
		(doc) ->
			return res.send false # client is suspected
	], callback

exports.removeMeFromSuspected = (req, res)->
	ip = req.connection.remoteAddress
	
	async.waterfall [
		(next) ->
			Model 'Suspected', 'findOne', next, ip_address: ip
		(doc, next) ->
			doc.remove next
		(doc) ->
			res.redirect '/'
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in lib/referrer/removeMeFromSuspected: #{error}"
		res.send false