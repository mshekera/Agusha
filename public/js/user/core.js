$(function() {
	var	menu_blocks = $('#header .dropdown_container'),
		i;
	
	for(i = menu_blocks.length; i--;) {
		var menu_block = $(menu_blocks[i]),
			span = menu_block.find('span'),
			span_width = span.outerWidth(),
			dropdown = menu_block.find('.dropdown'),
			dropdown_width = dropdown.width(),
			left;
		
		var offset = ((dropdown_width - span_width) / 2) | 0;
		
		if(offset > 0) {
			left = -offset;
		} else {
			left = 0;
		}
		
		dropdown.css({
			left: left
		});
	}
	
	menu_blocks = $('#footer .menu_block');
	
	for(i = menu_blocks.length; i--;) {
		var menu_block = $(menu_blocks[i]),
			width = menu_block.width() + 4;
		
		menu_block.css({
			width: width
		});
	}
});

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

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-53500731-1']);
_gaq.push(['_setSiteSpeedSampleRate', 20]);
_gaq.push(['_trackPageview']);
(function() {
	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	ga.src = ('https:' == document.location.protocol ?  'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();