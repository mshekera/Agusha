async = require 'async'
_ = require 'underscore'
request = require 'request'

Logger = require './logger'
Model = require './model'

exports.getChannelVideos = (name, callback) ->
	result = []
	
	async.waterfall [
		(next) ->
			requestString = 'http://gdata.youtube.com/feeds/api/users/' + name + '/uploads?alt=json'
			
			request requestString, next
		(response, body, next) ->
			json = JSON.parse body
			videos = json.feed.entry
			
			
			videosLength = videos.length
			while videosLength--
				video = videos[videosLength]
				item =
					id: video.id.$t.split('/').slice(-1)[0]
					title: video.title.$t
					published: video.published.$t
				
				result.push item
			
			Model 'Video', 'create', next, result
		() ->
			callback null, result
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in lib/youtube/getChannelVideos: #{error}"
		callback error