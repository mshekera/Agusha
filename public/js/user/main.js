var main_container = $('#main_container');
var slider_container = $('#slider_container');

var define_slider_size = function() {
	var main_container_width = main_container.width();
	var slider_height = (slider_container.height() | 0) + 1;
	var slides = slider_container.find('.slides');
	
	slider_container.css({
		width: main_container_width,
		height: slider_height
	});
	
	$('.slides').css({
		width: main_container_width,
		height: slider_height
	});
}

define_slider_size();

var options = {
	//$AutoPlay: true,
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
	var parentWidth = $('#slider_container').parent().width();
	
	jssor_slider.$SetScaleWidth(parentWidth);
}

window_resize();
if (!navigator.userAgent.match(/(iPhone|iPod|iPad|BlackBerry|IEMobile)/)) {
	$(window).bind('resize', window_resize);
}