exports.convertToSelect2Results = (data) ->
	result = []
	
	dataLength = data.length
	while dataLength--
		item = data[dataLength]
		converted = convertToSelect2Result item
		
		result.push converted
	
	return result

exports.convertToSelect2Result = convertToSelect2Result = (item) ->
	converted =
		id: item._id
		text: item.name
	
	return converted