var main_container = $('#main_container');
var slider_container = $('#slider_container');

var define_slider_size = function() {
	var main_container_width = main_container.width();
	
	slider_container.width(main_container_width);
	slider_container.find('.slides').width(main_container_width);
}

define_slider_size();

var options = {
	$AutoPlay: true,
	$SlideDuration: 800, 
	$BulletNavigatorOptions: {
		$Class: $JssorBulletNavigator$,
		$ChanceToShow: 2,
		$AutoCenter: 1,
		$SpacingX: 10
	},
	$ArrowNavigatorOptions: {
		$Class: $JssorArrowNavigator$,
		$ChanceToShow: 2,
		$AutoCenter: 2
	}
};
var jssor_slider = new $JssorSlider$('slider_container', options);

function window_resize() {
	define_slider_size();
	var parentWidth = $('#slider_container').parent().width();
	if (parentWidth) {
		jssor_slider.$SetScaleWidth(parentWidth);
	}
	else
		window.setTimeout(ScaleSlider, 30);
}

window_resize();
if (!navigator.userAgent.match(/(iPhone|iPod|iPad|BlackBerry|IEMobile)/)) {
	$(window).bind('resize', window_resize);
}