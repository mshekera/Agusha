define([
	'slider',
	'user/main'
],
	function() {
		return Controller.extend({
			defaults: {
				
			}
		}, {
			after_init: function () {
				
			},
			
			variables: function() {
				this.modules = $('#modules');
				this.slider_container = $('#slider_container');
			},
			
			plugins: function() {
				var options = {
					// $AutoPlay: true,
					$SlideDuration: 800, 
					$BulletNavigatorOptions: {
						$Class: $JssorBulletNavigator$,
						$ChanceToShow: 2,
						$SpacingX: 10
					},
					$ArrowNavigatorOptions: {
						$Class: $JssorArrowNavigator$,
						$ChanceToShow: 2,
					}
				};

				// var jssor_slider = new $JssorSlider$('slider_container', options);
			},
			
			sizes: function() {
				var	before_main_width = this.modules.width(),
					offset = ((1280 - before_main_width) / 2) | 0,
					left,
					i;
				
				if(offset > 0) {
					left = -offset;
				} else {
					left = 0;
				}
				
				this.slider_container.css({
					left: left
				});
			}
		});
	}
);