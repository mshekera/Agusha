$.validator.addMethod('mask',
    function(value, element, regexp) {
		var theregex = /_/;
        return this.optional(element) || !theregex.test(value);
    },
    'Некорректно указан номер. Попробуйте еще раз.'
);

Client = can.Model.extend({
	create: 'POST /signup/activate'
}, {});

var Activate_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.submitted = false;
			
			this.init_plugins();
		},
		
		init_plugins: function() {
			this.init_select2();
			this.init_inputmask();
		},
		
		init_inputmask: function() {
			$('#activate_phone').inputmask('+3 8(999) 999 - 99 - 99');
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
					quietMillis: 300,
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
		
		show_modal: function() {
			this.element.find('.message').easyModal({
				autoOpen: true,
				overlayOpacity: 0.9,
				overlayColor: "#ffffff",
				onClose: function(myModal) {
					_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
					_gaq.push(['_trackEvent', 'closeerror', 'click']);
				}
			});
		},
		
		'.form_radio .text click': function(el) {
			var	elem = $(el),
				radio = elem.prev().find('input');
			
			radio.prop('checked', true);
		},
		
		'.i_agree .text click': function(el) {
			var checkbox = $('#i_agree_checkbox');
			checkbox.prop('checked', !checkbox.prop('checked'));
		},
		
		'#city_select2 change': function(el) {
			var	elem = $(el),
				error = elem.next();
			
			if(error.length) {
				error.remove();
			}
		},
		
		'.rules click': function(el, ev) {
			ev.preventDefault();
			var href = href = $(el).attr('href');
			
			_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
			_gaq.push(['_trackEvent', 'rules', 'click']);
			
			location.href = href;
		},
		
		'#activate_form submit': function(el, ev) {
			ev.preventDefault();
			
			if(!this.submitted) {
				this.submitted = true;
			} else {
				return false;
			}
			
			var	radio = this.element.find('input[name=hasKids]:checked'),
				val = radio.val();
			
			if(val == 0) {
				this.show_modal();
				this.submitted = false;
				return false;
			}
			
			var form = $(el),
				valid;
			
			this.activate_validate(form);
			
			valid = form.valid();
			Placeholders.enable();
			
			if(valid == true) {
				var	data = form.serialize(),
					that = this;
				
				Client.create(data,
					function(response) {
						that.success_activation(response);
					}
				);
			} else {
				this.submitted = false;
			}
		},
		
		success_activation: function(response) {
			this.submitted = false;
			
			if(response.err) {
				$('#main_container').find('.message').find('.dark_font').html(response.err);
				this.show_error();
				return;
			}
			
			_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
			_gaq.push(['_trackEvent', 'send', 'click']);
			
			location.href = '/signup/success/' + response.data.id;
		},
		
		show_error: function() {
			$('.message').easyModal({
				autoOpen: true,
				overlayOpacity: 0.9,
				overlayColor: "#ffffff",
				onClose: function(myModal) {
					_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
					_gaq.push(['_trackEvent', 'closeerror', 'click']);
				}
			});
		},
		
		activate_validate: function(form) {
			var	validation = {rules: {}, messages: {}},
				rule,
				required_message = 'Это обязательное поле';
			
			rule = 'firstName';
			validation.rules[rule] = {
				required: true,
				minlength: 3,
				maxlength: 64
			};
			validation.messages[rule] = {
				required: required_message,
				minlength: 'Минимальное количество символов - 3',
				maxlength: 'Максимальное количество символов - 64'
			};
			
			rule = 'lastName';
			validation.rules[rule] = {
				required: true,
				minlength: 3,
				maxlength: 64
			};
			validation.messages[rule] = {
				required: required_message,
				minlength: 'Минимальное количество символов - 3',
				maxlength: 'Максимальное количество символов - 64'
			};
			
			rule = 'patronymic';
			validation.rules[rule] = {
				required: true,
				minlength: 3,
				maxlength: 64
			};
			validation.messages[rule] = {
				required: required_message,
				minlength: 'Минимальное количество символов - 3',
				maxlength: 'Максимальное количество символов - 64'
			};
			
			rule = 'phone';
			validation.rules[rule] = {
				required: true,
				mask: true
			};
			validation.messages[rule] = {
				required: required_message
			};
			
			rule = 'city';
			validation.rules[rule] = {
				required: true
			};
			validation.messages[rule] = {
				required: required_message
			};
			
			rule = 'postIndex';
			validation.rules[rule] = {
				required: true,
				number: true,
				minlength: 5,
				maxlength: 6
			};
			validation.messages[rule] = {
				required: required_message,
				number: 'Пожалуйста, введите число',
				minlength: 'Минимальное количество символов - 5',
				maxlength: 'Максимальное количество символов - 6'
			};
			
			rule = 'street';
			validation.rules[rule] = {
				required: true,
				minlength: 4,
				maxlength: 64
			};
			validation.messages[rule] = {
				required: required_message,
				minlength: 'Минимальное количество символов - 4',
				maxlength: 'Максимальное количество символов - 64'
			};
			
			rule = 'house';
			validation.rules[rule] = {
				required: true,
				maxlength: 8
			};
			validation.messages[rule] = {
				required: required_message,
				maxlength: 'Максимум 8 символов'
			};
			
			rule = 'apartment';
			validation.rules[rule] = {
				required: true,
				maxlength: 4
			};
			validation.messages[rule] = {
				required: required_message,
				maxlength: 'Максимум 4 символа'
			};
			
			rule = 'agree';
			validation.rules[rule] = {
				required: true
			};
			validation.messages[rule] = {
				required: 'Пожалуйста, подтвердите, что вы согласны с Правилами Акции'
			};
			
			validation.ignore = [];
			
			form.validate(validation);
		}
	}
);

new Activate_controller('#activate');