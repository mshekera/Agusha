if($('.thanks').length) {
	$('html, body').animate({
        scrollTop: 9999
    }, 1);
}

Client = can.Model.extend({
	create: 'POST /signup/register'
}, {});

var Signup_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.submitted = false;
		},
		
		'.rules click': function(el, ev) {
			ev.preventDefault();
			var href = href = $(el).attr('href');
			
			_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
			_gaq.push(['_trackEvent', 'rules', 'click']);
			
			location.href = href;
		},
		
		'#registration_form submit': function(el, ev) {
			ev.preventDefault();
			var form = $(el),
				that = this,
				valid;
			
			this.registration_validate(form);
			
			valid = form.valid();
			Placeholders.enable();
			
			if(valid == true) {
				if(!this.submitted) {
					this.submitted = true;
				} else {
					return false;
				}
				
				var	data = $(form).serialize()
				
				Client.create(data,
					function(response) {
						that.success_registration.call(that, response);
					}
				);
			}
		},
		
		success_registration: function(response) {
			this.submitted = false;
			
			if(response.err) {
				$('#main_container').find('.message').find('.dark_font').html(response.err);
				this.show_error();
				return;
			}
			
			_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
			_gaq.push(['_trackEvent', 'registration', 'click']);
			
			location.href = '/signup/registered';
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
		
		registration_validate: function(form) {
			var	validation = {rules: {}, messages: {}},
				rule,
				required_message = 'Это обязательное поле';
			
			rule = 'login';
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
			
			rule = 'email';
			validation.rules[rule] = {
				required: true,
				minlength: 3,
				maxlength: 64,
				email: true
			};
			validation.messages[rule] = {
				required: required_message,
				minlength: 'Минимальное количество символов - 3',
				maxlength: 'Максимальное количество символов - 64',
				email: 'Некорректно указан E-mail. Попробуйте еще раз.'
			};
			
			validation.ignore = [];
			
			form.validate(validation);
		}
	}
);

new Signup_controller('#signup');