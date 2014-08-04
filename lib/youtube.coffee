async = require 'async'
_ = require 'underscore'
request = require 'request'

Logger = require './logger'

exports.getChannelVideos = (name, callback) ->
	async.waterfall [
		(next) ->
			requestString = 'http://gdata.youtube.com/feeds/api/users/' + name + '/uploads?alt=json'
			
			request requestString, next
		(response, body) ->
			json = JSON.parse body
			videos = json.feed.entry
			result = []
			
			videosLength = videos.length
			while videosLength--
				video = videos[videosLength]
				item =
					id: video.id.$t.split('/').slice(-1)[0]
					title: video.title.$t
				
				result.push item
			
			callback null, result
	], (err) ->
		error = err.message or err
		Logger.log 'info', "Error in lib/youtube/getChannelVideos: #{error}"