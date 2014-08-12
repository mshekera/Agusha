moment = require 'moment'

exports.startOf = (label, day, format)->
	label = label || 'week'
	format = format || 'XSSS'

	moment().startOf(label).format format

exports.endOf = (label, day, format)->
	label = label || 'week'
	format = format || 'XSSS'

	moment().endOf(label).format format

exports.today = (format) ->
	moment().format format

exports.getDate = (val) ->
	if not val
		return val
	
	return moment(val).format('DD/MM/YYYY')

exports.getTimeDate = (val, seconds = true) ->
	if not val
		return val
	
	format = 'HH:mm' + (if seconds then ':ss' else '') + ' DD/MM/YYYY'
	return moment(val).format format

exports.getTimeDateBackwards = (val, seconds = true) ->
	if not val
		return val
	
	format = 'YYYY/MM/DD HH:mm' + (if seconds then ':ss' else '')
	return moment(val).format format

exports.setDate = (val) ->
	if not val
		return val
	
	return moment(val, 'DD/MM/YYYY').format('MM/DD/YYYY')

exports.declension = (digit, onlyword) ->
	onlyword = onlyword || true
	
	expr = 'день дня дней'
	
	digit = digit + ''
	res = ''
	expr_list = expr.split(' ')
	reg = /[^0-9]+/
	i = digit.replace(reg, '')
	if onlyword
		digit = ''
	if i >= 5 and i <= 20
		res = digit + ' ' + expr_list[2]
	else
		i %= 10
		if i is 1
			res = digit + ' ' + expr_list[0]
		else if i >= 2 and i <= 4
			res = digit + ' ' + expr_list[1]
		else
			res = digit + ' ' + expr_list[2]
	
	res.trim()