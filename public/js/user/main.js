// $('.unsubscribe_message').easyModal({
	// autoOpen: true,
	// overlayOpacity: 0.9,
	// overlayColor: "#ffffff",
	// onClose: function(myModal) {
		// _gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
		// _gaq.push(['_trackEvent', 'closeerror', 'click']);
		
		// location.href = '/';
	// }
// });

$('.prototype').corner('6px');
$('.live_program .photo').corner('60px');
$('.join_tour .photo').corner('63px');

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