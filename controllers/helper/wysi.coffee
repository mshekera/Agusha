fs = require 'fs'
_ = require 'underscore'
async = require 'async'
sprintf = require 'sprintf'

Logger = require '../../lib/logger'

exports.get = (req, res) ->
	fs.readdir "./public/img/admin/attachable", (err, files) ->
		if err
			msg = "Error in wysi get: #{err.message or err}"
			Logger.log 'error', msg
			return res.send false

		results = []
		for f in files
			results.push {
				file: "/attachable/#{f}"
				caption: ""
			}

		res.send results


exports.upload = (req, res) ->
	console.log req.files
	image = req.files['file'].name

	if req.files['attachment[file]']
		return res.json req.files['attachment[file]']

	error = "Error in wysi upload: #{err.message or err}"
	Logger.log 'error', error
	res.status 500
	res.json new Error error 
