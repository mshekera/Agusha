async = require 'async'

View = require '../../lib/view'
Admin = require '../../lib/admin'
Auth = require '../../lib/auth'

exports.index = (req, res) ->


exports.login = (req, res)->
	View.render 'admin/auth/login/index', res

exports.logout = (req, res)->
	req.logout()
	res.redirect '/admin/login'

exports.do_login = (req, res) ->
	Auth.authenticate('admin') req, res