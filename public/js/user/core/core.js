require.config({
	baseUrl: '/js',
	
	paths: {
		core: 'user/core',
		slider: 'plugins/slider/jssor.slider'
	},
	
	shim: {
		'slider': {
			deps: ['plugins/slider/jssor.core', 'plugins/slider/jssor.utils'],
			exports: '$JssorSlider$'
		}
	},
	
	map: {
		'*': {
			'css': 'plugins/require/require-css.min'
		}
	}
});

require([
		'core/router',
		'core/config'
	],
	function(
		Router,
		config
	) {
		var body = $('body');
		
		Controller = can.Control.extend({
			defaults: {
				
			}
		}, {
			init: function () {
				var server = $('#modules').find('.module.server');
				
				if(server.length) {
					this.element.html(server.html());
					server.remove();
				} else {
					this.request();
				}
				
				this.after_init();
				
				this.variables();
				this.sizes();
				this.plugins();
			},
			
			request: function() {
				var	str = this.options.module.path.server,
					params = ['name', 'id'],
					that = this,
					reg,
					i;
				
				for(i = params.length; i--;) {
					param = params[i];
					reg = new RegExp(':' + param, 'g');
					str = str.replace(reg, this.options.module[param]);
				}
				
				can.ajax({
					url: '/' + str,
					success: function(data) {
						that.successRequest(data);
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.error(errorThrown);
					}
				});
			},
			
			successRequest: function(data) {
				console.log(data);
			},
			
			variables: function() {
				
			},
			
			plugins: function() {
				
			},
			
			sizes: function() {
				
			},
			
			'{window} resize': 'sizes'
		});
		
		new Router(body, config.router);
	}
);