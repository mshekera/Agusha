async = require 'async'

View = require '../../lib/view'
Auth = require '../../lib/auth'

gallery = require '../../meta/gallery'

exports.index = (req, res) ->
	data =
		gallery: gallery
	
	View.render 'user/index', res, data