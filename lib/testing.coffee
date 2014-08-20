async = require 'async'
_ = require 'underscore'

View = require '../lib/view'
Model = require '../lib/model'
Logger = require '../lib/logger'

tree = require '../utils/tree'

breadcrumbs = require '../meta/breadcrumbs'

exports.index = (req, res) ->
	View.render 'user/testing/testing', res, null, req.path

exports.type = (req, res) ->
	type = req.params.type
	
	if type == 'cache'
		data =
			breadcrumbs: tree.findWithParents breadcrumbs, 'contacts'
		
		return View.render 'user/contacts/contacts', res, data, req.path
	
	View.render 'user/testing/' + type, res, null