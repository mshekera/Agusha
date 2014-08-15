exports.password = (pass) ->
	if (pass.length > 0) then true else false
	
exports.email = (val) ->
	regexp = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/
	regexp.test val

exports.ipAddressIpv4 = (val) ->
	regexp = /^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$/
	regexp.test val