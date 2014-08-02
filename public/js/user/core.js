$(function() {
	var	menu_blocks = $('#header .dropdown_container');
	
	for(i = menu_blocks.length; i--;) {
		var menu_block = $(menu_blocks[i]),
			span = menu_block.find('span'),
			span_width = span.outerWidth(),
			dropdown = menu_block.find('.dropdown'),
			dropdown_width = dropdown.width(),
			left;
		
		var offset = ((dropdown_width - span_width) / 2) | 0;
		
		if(offset > 0) {
			left = -offset;
		} else {
			left = 0;
		}
		
		dropdown.css({
			left: left
		});
	}
});