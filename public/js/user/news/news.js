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
						},
						
						url: {
							value: document.URL
						},
						
						vk_url: {
							value: encodeURIComponent(document.URL + '?utm_source=vkontakte&utm_medium=share&utm_campaign=light_viral_content')
						},
						
						ok_url: {
							value: encodeURIComponent(document.URL + '?utm_source=Odnoklassniki&utm_medium=share&utm_campaign=light_viral_content')
						},
						
						gp_url: {
							value: encodeURIComponent(document.URL + '?utm_source=googleplus&utm_medium=share&utm_campaign=light_viral_content')
						},
						
						fb_url: {
							value: encodeURIComponent(document.URL + '?utm_source=facebook&utm_medium=share&utm_campaign=light_viral_content')
						},
						
						tw_url: {
							value: encodeURIComponent(document.URL + '?utm_source=twitter&utm_medium=share&utm_campaign=light_viral_content')
						}
					}
				});
				
				this.data = new ViewModel();
				
				var view = can.view("#articles_tmpl", this.data, {
					showArrows: function(options) {
						return options.context.desc_image.length > 1 ? options.fn() : options.inverse();
					},
					startIndex: function(options) {
						window['INDEX'] = 0;
						return;
					},
					firstElem: function(options) {
						if(window['INDEX'] == 0) {
							window['INDEX']++;
							return options.fn();
						}
						return options.inverse();
					}
				});
				
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
			},
			
			'.desc_images_arrows .right click': function(el) {
				var	elem = $(el),
					article_block = elem.parents('.article_block'),
					id = article_block[0].id;
				
				this.next_image(id);
			},
			
			next_image: function(id) {
				var	classname = 'active',
					article_block = $('#' + id),
					images = article_block.find('.image'),
					active_image = images.filter('.' + classname);
				
				if(!active_image.length) {
					$(images[0]).addClass(classname);
					return;
				}
				
				images.removeClass(classname);
				
				var	next_image = active_image.next();
				
				if(!next_image.length) {
					$(images[0]).addClass(classname);
					return;
				}
				
				next_image.addClass(classname);
			},
			
			'.desc_images_arrows .left click': function(el) {
				var	elem = $(el),
					article_block = elem.parents('.article_block'),
					id = article_block[0].id;
				
				this.prev_image(id);
			},
			
			prev_image: function(id) {
				var	classname = 'active',
					article_block = $('#' + id),
					images = article_block.find('.image');
				
				if(images.length < 2) {
					return;
				}
				
				var	active_image = images.filter('.' + classname);
				
				if(!active_image.length) {
					$(images[0]).addClass(classname);
					return;
				}
				
				images.removeClass(classname);
				
				var	prev_image = active_image.prev();
				
				if(!prev_image.length) {
					$(images[images.length - 1]).addClass(classname);
					return;
				}
				
				prev_image.addClass(classname);
			}
		}
	);

	new News_controller('#news');
});