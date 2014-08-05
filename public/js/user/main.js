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

<!-- Yandex.Metrika counter -->
(function (d, w, c) {
    (w[c] = w[c] || []).push(function() {
        try {
            w.yaCounter25778882 = new Ya.Metrika({id:25778882,
                    webvisor:true,
                    clickmap:true,
                    trackLinks:true,
                    accurateTrackBounce:true});
        } catch(e) { }
    });

    var n = d.getElementsByTagName("script")[0],
        s = d.createElement("script"),
        f = function () { n.parentNode.insertBefore(s, n); };
    s.type = "text/javascript";
    s.async = true;
    s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js";

    if (w.opera == "[object Opera]") {
        d.addEventListener("DOMContentLoaded", f, false);
    } else { f(); }
})(document, window, "yandex_metrika_callbacks");
<!-- /Yandex.Metrika counter -->

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-53500731-1', 'auto');
ga('send', 'pageview');