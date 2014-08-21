async = require 'async'
_ = require 'underscore'
fs = require 'fs'

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

exports.images = (req, res) ->
	dir = __dirname + '/../public/img/uploads/x220';
	
	async.waterfall [
		(next) ->
			fs.readdir dir, next
		(files) ->
			data =
				files: files
			
			View.render 'user/testing/images', res, data, req.path
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/signup/activate: #{error}"