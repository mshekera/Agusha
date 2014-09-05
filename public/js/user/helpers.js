function strip_tags(str){	// Strip HTML and PHP tags from a string
	// 
	// +   original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
	
	return str.replace(/<\/?[^>]+>/gi, '');
}

function jadeTemplate(name, data){
	var response = $.ajax({
		url: 'views/' + name,
		dataType: "view",
		async: false
	});
	
	var template = new Function(response.responseText)();
	
	return template(data);
}