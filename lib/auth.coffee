url = require 'url'

passport = require 'passport'

params =
	admin:
		failureRedirect: '/admin/login'
		successRedirect: '/admin'
		session: true
	catalog:
		failureRedirect: '/account/signin'
		successRedirect: '/account'
		session: true

exports.isAuth = (req, res, next)->
	path = url.parse req.path

	if path.path == '/auth'
		return next()

	if not req.user or not req.isAuthenticated()
		return res.redirect '/admin/auth'

	next()

exports.authenticate = (strategy) ->
	passport.authenticate strategy, params[strategy]
