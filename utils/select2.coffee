exports.convertToSelect2Results = (result, data, callback) ->
	converted =
		id: data._id
		text: data.name
	
	result.push converted
	callback()