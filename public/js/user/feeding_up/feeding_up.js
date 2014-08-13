$('.image').corner('31px');
$('.hover_image').corner('34px');
$('.warning').corner('29px');

var Feeding_up_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			
		},
		
		'.td.hoverable click': function(el, ev) {
			var	elem = $(el),
				month = elem.data('month'),
				hoverable = this.element.find('.td.hoverable'),
				classname = 'chosen';
			
			hoverable.removeClass(classname);
			hoverable.filter('.' + month + 'm').addClass(classname);
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
		},
		
		'.print click': function() {
			this.print('feeding_up_table');
		},
		
		print: function(id) {
			var printContents = document.getElementById(id).innerHTML;
			var originalContents = document.body.innerHTML;
			
			document.body.innerHTML = printContents;
			
			window.print();
			
			document.body.innerHTML = originalContents;
		}
	}
);

new Feeding_up_controller('body');