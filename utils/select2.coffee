exports.convertToSelect2Results = (data) ->
	result = []
	
	dataLength = data.length
	while dataLength--
		item = data[dataLength]
		converted =
			id: item._id
			text: item.name
		
		result.push converted
	
	return result