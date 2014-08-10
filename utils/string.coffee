exports.strip_tags = (str) ->
	str.replace /<\/?[^>]+>/g, ' '