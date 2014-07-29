var Article_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			
		},
		
		'.dyk_button click': function(el) {
			var element = $(el),
				val = element.data('dyk');
			
			this.element.find('.dyk_block').removeClass('active');
			this.element.find('.dyk_button').removeClass('active');
			this.element.find('.dyk_' + val).addClass('active');
		}
	}
);

new Article_controller('#article_' + article._id);