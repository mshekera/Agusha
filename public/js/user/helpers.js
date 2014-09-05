function strip_tags(str){	// Strip HTML and PHP tags from a string
	// 
	// +   original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
	
	return str.replace(/<\/?[^>]+>/gi, '');
}