$('.message').easyModal({
	autoOpen: true,
	overlayOpacity: 0.9,
	overlayColor: "#ffffff",
});

moment.lang('ru');

var base_url = window.location.protocol + '//' + window.location.host;

var Tour_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.mapLatLng = new google.maps.LatLng(50.4300000, 30.389388);
			this.akademLatLng = new google.maps.LatLng(50.4648609, 30.3553083);
			this.vishnevoeLatLng = new google.maps.LatLng(50.3856838, 30.3471481);
			
			this.tour_key = 0;
			this.tours = tours;

			this.preformat_tours();
			
			var ViewModel = can.Map.extend({
				define: {
					current_tour: {
						value: this.tours[0] || null
					}
				}
			});
			
			this.data = new ViewModel();
			
			$('#form_topper_date').html(can.view("#topper_date_tmpl", this.data));
			
			this.init_plugins();
		},
		
		preformat_tours: function() {
			var i;
			
			for(i = this.tours.length; i--;) {
				var	tour = this.tours[i],
					date = moment(tour.date),
					two_words = date.calendar().split(' ', 2).join(' '),
					string_date = date.format('LL').split(' ', 3).join(' ');
				
				tour.formattedDate = date.format('DD/MM/YYYY');
				tour.topperDate = two_words + ' ' + string_date;
			}
		},
		
		init_plugins: function() {
			this.init_map();
			this.init_calendar();
			this.init_inputmask();
			this.init_select2();
			this.init_slider();
		},
		
		init_map: function() {
			var	that = this,
				directionsDisplay = new google.maps.DirectionsRenderer({suppressMarkers: true}),
				directionsService = new google.maps.DirectionsService();
			
			var	options = {
					center: this.mapLatLng,
					zoom: 12
				};
			
			this.map = new google.maps.Map(document.getElementById('tour_map'), options);
			
			directionsDisplay.setMap(this.map);
			
			var request = {
				origin: this.akademLatLng,
				destination: this.vishnevoeLatLng,
				travelMode: google.maps.TravelMode.DRIVING
			};
			
			directionsService.route(request, function(response, status) {
				if (status == google.maps.DirectionsStatus.OK) {
					directionsDisplay.setDirections(response);
				} else {
					that.draw_route();
				}
			});
			
			this.draw_markers();
		},
		
		draw_markers: function() {
			new google.maps.Marker({
				position: this.akademLatLng,
				map: this.map,
				icon: base_url + '/img/user/tour/akadem_marker.png'
			});
			
			new google.maps.Marker({
				position: this.vishnevoeLatLng,
				map: this.map,
				icon: base_url + '/img/user/tour/agusha_marker.png'
			});
		},
		
		draw_route: function() {
			var polylineCoords = [
				this.akademLatLng,
				this.vishnevoeLatLng
			];
			
			var polyline = new google.maps.Polyline({
				path: polylineCoords,
				strokeColor: "#64cb81",
				strokeOpacity: 1.0,
				strokeWeight: 6
			});
			
			polyline.setMap(this.map);
		},
		
		init_calendar: function() {
			var that = this,
				calendar = $('#calendar'),
				current_date = new Date();
			
			calendar.datepicker({
				defaultDate: current_date,
				hideIfNoPrevNext: true,
				minDate: current_date,
				maxDate: new Date(current_date.valueOf() + 1000 * 3600 * 24 * 364),
				beforeShowDay: function(date) {
					var	calendar_date = moment(date).format('DD/MM/YYYY'),
						i;
					
					for(i = that.tours.length; i--;) {
						var tour = that.tours[i];
						
						if(calendar_date == tour.formattedDate) {
							return [true, 'has_event', ''];
						}
					}
					
					return [true];
				},
				onSelect: function(dateText) {
					var i;
					
					for(i = that.tours.length; i--;) {
						var tour = that.tours[i];
						
						if(dateText == tour.formattedDate) {
							that.data.attr('current_tour', tour._id);
							
							that.tour_key = i;
							that.change_tour();
							return;
						}
					}
				}
			});
			
			if(typeof(this.tours[0]) != 'undefined' && this.tours[0]) {
				calendar.datepicker('setDate', this.tours[0].formattedDate);
			}
		},
		
		init_inputmask: function() {
			this.phone_inputmask();
			this.age_inputmask();
		},
		
		phone_inputmask: function() {
			$('#tour_phone').inputmask('+3 8(999) 999 - 99 - 99');
		},
		
		age_inputmask: function() {
			$('.child_age').inputmask('99 месяцев');
		},
		
		init_select2: function() {
			var options = this.select2_options();
			$('#city_select2').select2(options);
		},
		
		select2_options: function() {
			return {
				width: '100%',
				minimumInputLength: 3,
				ajax: {
					url: '/city_autocomplete',
					type: 'post',
					dataType: 'json',
					data: function (term, page) {
						return {
							term: term
						};
					},
					results: function (data, page) {
						return {results: data};
					}
				},
				placeholder: 'Город проживания',
				formatSearching: 'Поиск...',
				formatNoMatches: 'За вашим запросом ничего не найдено',
				formatInputTooShort: function (input, min) {
					var n = min - input.length;
					return 'Пожалуйста, введите еще ' + n + ' символ' + (n == 1 ? '' : 'а') + ' города';
				}
			}
		},
		
		init_slider: function() {
			$('#tour_gallery').slick({
				slidesToShow: 3,
				slidesToScroll: 1,
				//autoplay: true,
				//dots: true,
				draggable: false
			});
		},
		
		'.step_button click': function(el) {
			var element = $(el),
				val = element.data('step'),
				calendar_block_inside = $('#calendar_block_inside');
			
			calendar_block_inside.find('.step').removeClass('active');
			calendar_block_inside.find('.step_button').removeClass('active');
			calendar_block_inside.find('.step_' + val).addClass('active');
		},
		
		'.prev_tour click': function(el) {
			if(this.tour_key == 0) {
				return;
			}
			
			this.tour_key--;
			this.change_tour(this.tour_key);
		},
		
		'.next_tour click': function(el) {
			if(this.tour_key == this.tours.length - 1) {
				return;
			}
			
			this.tour_key++;
			this.change_tour();
		},
		
		change_tour: function() {
			var	tour = this.tours[this.tour_key],
				closest_block_inside = $('#closest_block_inside');
			
			this.data.attr('current_tour', tour);
			
			$('#calendar').datepicker('setDate', tour.formattedDate);
			closest_block_inside.find('.tour_block').removeClass('active');
			$('#tour_' + this.tour_key).addClass('active');
		},
		
		'#add_child click': function(el) {
			var child_block = $('.child_block'),
				i = child_block.length,
				data = {
					i: i
				};
			
			$('#children_container').append(can.view("#add_child_tmpl", data));
			this.age_inputmask();
		},
		
		'#tour_form submit': function(el, ev) {
			var form = $(el);
			this.tour_validate(form);
			
			if(form.valid() == true) {
				return true;
			} else {
				return false;
			}
		},
		
		tour_validate: function(form) {
			var	validation = {rules: {}, messages: {}},
				rule,
				child_items = $('.child_block'),
				i;
			
			rule = 'firstname';
			validation.rules[rule] = {
				required: true,
				minlength: 3,
				maxlength: 64
			};
			
			rule = 'email';
			validation.rules[rule] = {
				required: true,
				minlength: 8,
				maxlength: 64,
				email: true
			};
			
			rule = 'lastname';
			validation.rules[rule] = {
				required: true,
				minlength: 3,
				maxlength: 64
			};
			
			rule = 'patronymic';
			validation.rules[rule] = {
				required: true,
				minlength: 3,
				maxlength: 64
			};
			
			rule = 'phone';
			validation.rules[rule] = {
				required: true,
				minlength: 3,
				maxlength: 64
			};
			
			rule = 'city';
			validation.rules[rule] = {
				required: true
			};
			
			for(i = child_items.length; i--;) {
				this.validate_child_name(validation, i);
			}
			
			for(i = child_items.length; i--;) {
				this.validate_child_age(validation, i);
			}
			
			validation.ignore = [];
			
			form.validate(validation);
		},
		
		validate_child_name: function(validation, i) {
			rule = 'children[' + i + '][name]';
			validation.rules[rule] = {
				minlength: 3,
				maxlength: 64,
				required: function(element){
					var	val = $("input[name='children[" + i + "][age]']").val();
					return (val.length > 0 && val != '__ месяцев');
				}
			};
		},
		
		validate_child_age: function(validation, i) {
			rule = 'children[' + i + '][age]';
			validation.rules[rule] = {
				minlength: 3,
				maxlength: 64,
				required: function(element){
					return $("input[name='children[" + i + "][name]']").val().length > 0;
				}
			};
		}
	}
);

new Tour_controller('#tour');