async = require 'async'

View = require '../../lib/view'
Model = require '../../lib/model'
Logger = require '../../lib/logger'
Youtube = require '../../lib/youtube'

tree = require '../../utils/tree'

breadcrumbs = require '../../meta/breadcrumbs'

exports.index = (req, res) ->
	data =
		breadcrumbs: tree.findWithParents breadcrumbs, 'video'
	
	async.waterfall [
		(next) ->
			Model 'Video', 'find', next
			# Youtube.getChannelVideos 'agushaukraine', next
		(videos) ->
			data.videos = videos
			
			View.render 'user/video/video', res, data, req.path
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in controllers/user/video/index: #{error}"
		res.send error