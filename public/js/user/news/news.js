Article = can.Model.extend({
	findAll: 'POST /articles/findAll',
	parseModels: function(data) {
		return data.data.articles;
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
					
					articles: {
						value: new can.List(articles),
						get: function(currentValue) {
							var options = {
								type: this.attr('type'),
							};
							
							if(that.first_call) {
								that.first_call = false;
							} else {
								currentValue.replace(Article.findAll(options));
							}
							
							return currentValue;
						}
					}
				}
			});
			
			this.data = new ViewModel();
			
			$('#articles_container').html(can.view("#articles_tmpl", this.data));
		},
		
		'.choose_type click': function(el) {
			var element = $(el),
				val = element.data('type'),
				choose_type = this.element.find('.choose_type');
			
			choose_type.removeClass('active');
			element.addClass('active');
			
			this.data.attr('type', val);
		}
	}
);

new News_controller('#news');