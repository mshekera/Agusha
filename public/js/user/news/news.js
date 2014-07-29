$(function() {
	Article = can.Model.extend({
		findAll : function(data){
			return $.ajax({
				async: false,
				data: data,
				url: '/articles/findAll',
				type: 'POST',
				dataType: 'json'
			})
		},
		parseModel: function(data) {
			return data;
		}
	}, {});

	var News_controller = can.Control.extend(
		{
			defaults: {
				
			}
		},
		
		{
			init: function () {
				var that = this;
				
				this.first_call = true;
				
				var ViewModel = can.Map.extend({
					define: {
						type: {
							value: null
						},
						
						force: {
							value: null
						},
						
						articles: {
							value: new can.Map(articles),
							get: function(currentValue, callback) {
								var force = this.attr('force');
								var self = this;
								
								var options = {
									type: this.attr('type'),
								};
								
								if(that.first_call) {
									that.first_call = false;
									return currentValue;
								} else {
									Article.findAll(options).done(function(data) {
										currentValue = data[0];
									});
								}
								
								return currentValue;
							}
						}
					}
				});
				
				this.data = new ViewModel();
				
				var view = can.view("#articles_tmpl", this.data);
				
				$('#articles_container').html(view);
			},
			
			'.choose_type click': function(el) {
				var element = $(el),
					val = element.data('type'),
					choose_type = this.element.find('.choose_type');
				
				choose_type.removeClass('active');
				element.addClass('active');
				
				this.data.attr('type', val);
			},
			
			'.refresh_articles click': function() {
				this.data.attr('force', {});
			},
			
			'.expand > div click': function(el) {
				var	elem = $(el),
					text = elem.closest('.text');
				
				text.toggleClass('active');
			}
		}
	);

	new News_controller('#news');
});