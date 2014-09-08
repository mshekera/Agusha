require.config({
	baseUrl: '/js',
	urlArgs: 'cb=' + Math.random(),
	paths: {
		
	},
	map: {
		'*': {
			'css': 'require-css/css'
		}
	},
	shim: {
		
	}
});

require([
		'user/core/core'
	], function(Core) {
		var specs = [];

		specs.push('user/products/products_test');

		$(function() {		
			require(specs, function() {
				
			});
		});
});