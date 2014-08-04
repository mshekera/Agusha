var Video_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.classname = 'active';
			this.video_container = this.element.find('.video_container');
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
			this.check_video();
			
			this.video_blocks = this.video_selectors.filter('.video_block');
			var	player_to_stop = this.video_blocks.filter('.active');
			
			player_to_stop.clone().appendTo(this.video_container);
			player_to_stop.remove();
			
			this.video_selectors = this.element.find('.video_selector');
			this.video_selectors.removeClass(this.classname);
			this.video_selectors.filter('.' + this.video).addClass(this.classname);
		},
		
		check_video: function() {
			var block = this.video_container.find('.' + this.video);
			if(!block.length) {
				var new_block = $('<div/>', {
						'class': 'video_block video_selector ' + this.video
					}),
					player = $('<object/>', {
						width: '100%',
						height: '100%',
						allowfullscreen: 'true',
						allowscriptaccess: 'always',
						wmode: 'transparent',
						frameborder: 0
					});
				
				new_block.appendTo(this.video_container);
				player.appendTo(new_block);
				player.attr('data', 'http://youtube.com/embed/' + this.video)
			}
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