var Feeding_up_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			
		},
		
		'.td.hoverable mouseleave': function(el, ev) {
			
		},
		
		'.td.hoverable mouseenter': function(el, ev) {
			var	elem = $(el),
				month = elem.data('month'),
				hoverable = this.element.find('.td.hoverable'),
				classname = 'active';
			
			hoverable.removeClass(classname);
			hoverable.filter('.' + month + 'm').addClass(classname);
		},
		
		'#feeding_up_select change': function(el) {
			var	elem = $(el),
				val = elem.val(),
				tblock = this.element.find('.tblock'),
				table = tblock.filter('#table_' + val),
				classname = 'active';
			
			tblock.removeClass(classname);
			table.addClass(classname);
		}
	}
);

new Feeding_up_controller('#feeding_up');