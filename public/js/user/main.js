var main_container = $('#main_container');
var slider_container = $('#slider_container');

var define_slider_size = function() {
	var width = main_container.width();
	var height = (width * 0.366) | 0;
	var slides = slider_container.find('.slides');
	var options = {
		width: width,
		height: height
	};
	
	slider_container.css(options);
	slider_container.find('> div').css(options);
	slider_container.find('.slider').css(options);
	slides.css(options);
	slides.find('> div').css(options);
}

var options = {
	//$AutoPlay: true,
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

var window_resize = function() {
	define_slider_size();
}

window_resize();

if (!navigator.userAgent.match(/(iPhone|iPod|iPad|BlackBerry|IEMobile)/)) {
	$(window).bind('resize', window_resize);
}