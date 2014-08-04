var Video_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.classname = 'active';
			this.video_titles = this.element.find('.video_title');
			this.video_blocks = this.element.find('.video_block');
			this.video = this.video_blocks.filter('.active').data('id');
			
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
			this.video_blocks.removeClass(this.classname);
			this.video_blocks.filter('.' + this.video).addClass(this.classname);
			
			this.video_titles.removeClass(this.classname);
			this.video_titles.filter('.' + this.video).addClass(this.classname);
		}
	}
);

new Video_controller('#video');