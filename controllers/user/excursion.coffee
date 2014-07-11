async = require 'async'

View = require '../../lib/view'
Logger = require '../../lib/logger'
Model = require '../../lib/model'

exports.index = (req, res) ->
	View.renderWithError req, res, 'user/excursion/excursion'