async = require 'async'

passport = require 'passport'
localStrategy = require('passport-local').Strategy

mongoose = require 'mongoose'
User = mongoose.models['user']

parameters =
	usernameField: 'username'
	passwordField: 'password'

passport.serializeUser (user, done) ->
	done null, user.id

passport.deserializeUser (id, done) ->

	async.waterfall [
		(next)->
			query =
				_id: id

			User.findOne(query)
				.populate('role address')
				.exec next
		(user, next) ->
			done null, user
	], done

validation = (err, user, password, done) ->
	if err
		return done err
	if not user
		return done null, false, { message: 'User is not exist' }
	if not user.validPassword password
		return done null, false, { message: 'Password is not valid' }

	done null, user

callbackStrategy = (username, password, done)->
	User.findOne
		username: username
	, (err, user)->
		validation err, user, password, done

exports.init = (callback)->
	adminAuth = new localStrategy callbackStrategy
	clientAuth = new localStrategy callbackStrategy

	passport.use 'admin', adminAuth
	passport.use 'client', clientAuth

	callback()