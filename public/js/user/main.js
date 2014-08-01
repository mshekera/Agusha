var	before_main = $('#before_main'),
	slider_container = $('#slider_container'),
	slides = slider_container.find('.slides');

var window_resize = function() {
	var	before_main_width = $('#before_main').width(),
		offset = ((1280 - before_main_width) / 2) | 0,
		left;
	
	if(offset > 0) {
		left = -offset;
	} else {
		left = 0;
	}
	
	slider_container.css({
		left: left
	});
}

window_resize();

var options = {
	width: 1280,
	height: 469
};

slides.css(options);

var options = {
	$AutoPlay: true,
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

var jssor_slider = new $JssorSlider$('slider_container', options);

if (!navigator.userAgent.match(/(iPhone|iPod|iPad|BlackBerry|IEMobile)/)) {
	$(window).bind('resize', window_resize);
}