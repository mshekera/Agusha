Product = can.Model.extend({
	findAll: 'POST /products/findAll',
	parseModels: function(data) {
		return data.data.products;
	}
}, {});

var Products_controller = can.Control.extend(
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
					age: {
						value: null
					},
					
					category: {
						value: null
					},
					
					products: {
						value: new can.List(products),
						get: function(currentValue) {
							var options = {
								age: this.attr('age'),
								category: this.attr('category')
							};
							
							if(that.first_call) {
								that.first_call = false;
							} else {
								currentValue.replace(Product.findAll(options));
							}
							
							return currentValue;
						}
					}
				}
			});
			
			this.data = new ViewModel();
			
			$('#products_container').html(can.view("#products_tmpl", this.data, {
				ageLevel: function(options) {
					return options.context.age.level < 12 ? options.fn() : options.inverse();
				}
			}));
		},
		
		'.age_block click': function(el) {
			var element = $(el),
				val = element.data('level'),
				age_blocks = this.element.find('.age_block');
			
			age_blocks.removeClass('active');
			element.addClass('active');
			
			this.data.attr('age', val);
			
			if(val != null) {
				$('#products_articles .products_article').removeClass('active');
				$('#age_' + val).addClass('active');
			}
		},
		
		'.choose_category click': function(el) {
			var element = $(el),
				val = element.data('category'),
				choose_categories = this.element.find('.choose_category');
			
			choose_categories.removeClass('active');
			element.addClass('active');
			
			this.data.attr('category', val);
		}
	}
);

new Products_controller('#products');