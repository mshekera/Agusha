var Video_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.classname = 'active';
			this.video_selectors = this.element.find('.video_selector');
			this.video_blocks = this.video_selectors.filter('.video_block');
			this.video = this.video_blocks.filter('.active').data('id');
			
			this.init_plugins();
		},
		
		init_plugins: function() {
			this.init_slider();
		},
		
		init_slider: function() {
			this.slider = $('#video_gallery').slick({
				slidesToShow: 3,
				slidesToScroll: 1,
				//autoplay: true,
				//dots: true,
				arrows: false,
				draggable: false
			});
		},
		
		'.small_video_clicker click': function(el) {
			var	elem = $(el),
				video = elem.data('id');
			
			if(this.video != video) {
				this.video = video;
				this.change_video();
			}
		},
		
		change_video: function() {
			this.video_selectors.removeClass(this.classname);
			this.video_selectors.filter('.' + this.video).addClass(this.classname);
		},
		
		'.arrow_left click': function() {
			this.slider.slickPrev();
		},
		
		'.arrow_right click': function() {
			this.slider.slickNext();
		}
	}
);

new Video_controller('#video');