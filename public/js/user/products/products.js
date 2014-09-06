define([
	
],
	function () {
		// function isLocalStorageAvailable() {
			// try {
				// return 'localStorage' in window && window['localStorage'] !== null;
			// } catch (e) {
				// return false;
			// }
		// }

		// if(isLocalStorageAvailable()) {
			// var minimized = localStorage['minimized_articles'];
			
			// if(minimized === 'true') {
				// $('#products_articles').addClass('minimized');
			// }
		// }
		
		// $('.choose_category').corner('15px');
		
		var Product = can.Model.extend({
			findAll: 'POST /products/findAll',
			parseModels: function(data) {
				return data.data.products;
			}
		}, {});
		
		return Controller.extend(
			{
				defaults: {
					
				}
			},
			
			{
				after_init: function(data) {
					var that = this,
						products;
					
					this.first_call = true;
					
					if(data) {
						products = data.products;
					} else {
						products = app.products;
					}
					
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
									
									if(!that.first_call) {
										currentValue.replace(Product.findAll(options));
									}
									
									return currentValue;
								}
							}
						}
					});
					
					this.data = new ViewModel();
					
					var product_stache = $('#product_stache');
					
					if(!product_stache.length) {
						// var html = ectRenderer.render('user/products/product_stache');
						var html = jadeTemplate.get('user/products/product_stache');
						
						can.view.stache('product', html);
					} else {
						can.view.stache('product', product_stache.html());
					}
					
					$('#products_container').html(can.view('product', this.data, {
						ageLevel: function(options) {
							if(options.context.age) {
								return options.context.age.level < 12 ? options.fn() : options.inverse();
							}
							
							return options.fn();
						}
					}));
					
					this.first_call = false;
				},
				
				'.age_block click': function(el) {
					var element = $(el),
						val = element.data('level'),
						age_blocks = this.element.find('.age_block'),
						products_articles = $('#products_articles');
					
					age_blocks.removeClass('active');
					element.addClass('active');
					
					this.data.attr('age', val);
					
					if(typeof(val) != 'undefined' && val != null) {
						products_articles.addClass('active');
						products_articles.find('.products_article').removeClass('active');
						$('#age_' + val).addClass('active');
					} else {
						products_articles.removeClass('active');
					}
				},
				
				'.choose_category click': function(el) {
					var element = $(el),
						val = element.data('category'),
						choose_categories = this.element.find('.choose_category');
					
					choose_categories.removeClass('active');
					element.addClass('active');
					
					this.data.attr('category', val);
				},
				
				'.minimize span click': function() {
					var	products_articles = $('#products_articles'),
						classname = 'minimized';
					
					products_articles.toggleClass(classname);
					
					if(isLocalStorageAvailable()) {
						localStorage['minimized_articles'] = products_articles.hasClass(classname);
					}
				}
			}
		);
	}
);


// var Products_controller = can.Control.extend(
	// {
		// defaults: {
			
		// }
	// },
	
	// {
		// init: function () {
			// var that = this;
			
			// this.first_call = true;
			
			// var ViewModel = can.Map.extend({
				// define: {
					// age: {
						// value: null
					// },
					
					// category: {
						// value: null
					// },
					
					// products: {
						// value: new can.List(products),
						// get: function(currentValue) {
							// var options = {
								// age: this.attr('age'),
								// category: this.attr('category')
							// };
							
							// if(that.first_call) {
								// that.first_call = false;
							// } else {
								// currentValue.replace(Product.findAll(options));
							// }
							
							// return currentValue;
						// }
					// }
				// }
			// });
			
			// this.data = new ViewModel();
			
			// $('#products_container').html(can.view("#products_tmpl", this.data, {
				// ageLevel: function(options) {
					// return options.context.age.level < 12 ? options.fn() : options.inverse();
				// }
			// }));
		// },
		
		// '.age_block click': function(el) {
			// var element = $(el),
				// val = element.data('level'),
				// age_blocks = this.element.find('.age_block'),
				// products_articles = $('#products_articles');
			
			// age_blocks.removeClass('active');
			// element.addClass('active');
			
			// this.data.attr('age', val);
			
			// if(typeof(val) != 'undefined' && val != null) {
				// products_articles.addClass('active');
				// products_articles.find('.products_article').removeClass('active');
				// $('#age_' + val).addClass('active');
			// } else {
				// products_articles.removeClass('active');
			// }
		// },
		
		// '.choose_category click': function(el) {
			// var element = $(el),
				// val = element.data('category'),
				// choose_categories = this.element.find('.choose_category');
			
			// choose_categories.removeClass('active');
			// element.addClass('active');
			
			// this.data.attr('category', val);
		// },
		
		// '.minimize span click': function() {
			// var	products_articles = $('#products_articles'),
				// classname = 'minimized';
			
			// products_articles.toggleClass(classname);
			
			// if(isLocalStorageAvailable()) {
				// localStorage['minimized_articles'] = products_articles.hasClass(classname);
			// }
		// }
	// }
// );

// new Products_controller('#products');