var Video_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.init_plugins();
		},
		
		init_plugins: function() {
			this.init_slider();
		},
		
		init_slider: function() {
			$('#video_gallery').slick({
				slidesToShow: 3,
				slidesToScroll: 1,
				//autoplay: true,
				//dots: true,
				draggable: false
			});
		}
	}
);

new Video_controller('#video');