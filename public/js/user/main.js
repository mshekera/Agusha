$('.unsubscribe_message').easyModal({
	autoOpen: true,
	overlayOpacity: 0.9,
	overlayColor: "#ffffff",
	onClose: function(myModal) {
		_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
		_gaq.push(['_trackEvent', 'closeerror', 'click']);
	}
});

var	before_main = $('#before_main'),
	slider_container = $('#slider_container'),
	menu_blocks = $('#header .dropdown');

var window_resize = function() {
	var	before_main_width = $('#before_main').width(),
		offset = ((1280 - before_main_width) / 2) | 0,
		left,
		i;
	
	if(offset > 0) {
		left = -offset;
	} else {
		left = 0;
	}
	
	slider_container.css({
		left: left
	});
	
	for(i = menu_blocks.length; i--;) {
		var menu_block = $(menu_blocks[i]),
			span = menu_block.find('span'),
			span_width = span.width(),
			dropdown = menu_block.find('.dropdown'),
			dropdown_width = dropdown.width();
		
		var offset = ((dropdown_width - span_width) / 2) | 0;
	}
}

window_resize();

var options = {
	width: 1280,
	height: 469
};

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

var jssor_slider = new $JssorSlider$('slider_container', options);

$('.prototype').corner('6px');
$('.live_program .photo').corner('60px');
$('.join_tour .photo').corner('63px');
$('#footer #marker .item').corner('17px');


if (!navigator.userAgent.match(/(iPhone|iPod|iPad|BlackBerry|IEMobile)/)) {
	$(window).bind('resize', window_resize);
}

$('.bannertop').click(function(ev) {
	ev.preventDefault();
	var href = ev.target.href;
	
	_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
	_gaq.push(['_trackEvent', 'bannertop', 'click']);
	
	location.href = href;
});

$('.bannerleft').click(function(ev) {
	ev.preventDefault();
	var href = $(this).attr('href');
	
	_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
	_gaq.push(['_trackEvent', 'bannerleft', 'click']);
	
	location.href = href;
});