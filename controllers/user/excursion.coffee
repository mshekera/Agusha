async = require 'async'

View = require '../../lib/view'
Auth = require '../../lib/auth'
Logger = require '../../lib/logger'
Model = require '../../lib/model'
Mail = require '../../lib/mail'

exports.index = (req, res) ->
	renderView req, res, 'user/excursion/excursion'