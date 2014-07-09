async = require 'async'

View = require '../../lib/view'
Auth = require '../../lib/auth'

exports.index = (req, res) ->
	View.render 'user/index', res