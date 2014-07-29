async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'
feeding_up = require '../../meta/feeding_up'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'feeding_up'
		feeding_up: feeding_up
	
	View.render 'user/feeding_up/feeding_up', res, data