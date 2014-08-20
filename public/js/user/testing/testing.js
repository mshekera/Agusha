var Testing_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			
		},
		
		'.testing_button click': function(el) {
			var id = el.attr('id'),
				span = el.next(),
				url = '/testing/' + id,
				start = new Date(),
				finish,
				amount,
				img;
			
			img = $('<img/>', {
				'src': '/img/processing.gif'
			});
			
			span.html(img);
			
			async.times(1000, function(n, next){
				$.ajax({
					url: url
				}).done(function(data) {
					next();
				});
			}, function(err, users) {
				finish = new Date();
				amount = finish.getTime() - start.getTime();
				
				span.html(amount + 'ms.');
			});
		},
		
		'#cache_button click': function(el) {
			var url = '/testing/cache',
				span = el.next(),
				start,
				finish,
				amount,
				img;
			
			img = $('<img/>', {
				'src': '/img/processing.gif'
			});
			
			span.html(img);
			
			$.ajax({
				url: url
			}).done(function(data) {
				start = new Date();
				
				async.times(1000, function(n, next){
					$.ajax({
						url: url
					}).done(function(data) {
						next();
					});
				}, function(err, users) {
					finish = new Date();
					amount = finish.getTime() - start.getTime();
					
					span.html(amount + 'ms.');
				});
			});
		}
	}
);

new Testing_controller('body');