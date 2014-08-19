Client = can.Model.extend({
	create: 'POST /signup/invite'
}, {});

var Invite_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.submitted = false;
		},
		
		'#add_client click': function(el) {
			var client_block = this.element.find('.client_block');
			var template = $('#add_client_tmpl').html();
			var i = client_block.length;
			
			var html = _.template(template, {
				i: i
			});
			
			$('#client_container').append(html);
		},
		
		'#invite_form submit': function(el, ev) {
			ev.preventDefault();
			
			if(!this.submitted) {
				this.submitted = true;
			} else {
				return false;
			}
			
			var form = $(el),
				valid;
			
			this.invite_validate(form);
			
			valid = form.valid();
			Placeholders.enable();
			
			if(valid == true) {
				var	data = $(form).serialize(),
					that = this;
				
				Client.create(data,
					function(response) {
						that.success_invite(response);
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
			_gaq.push(['_trackEvent', 'invite', 'click']);
			
			
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
		
		validate_login: function(validation, i) {
			var required_message = 'Это обязательное поле',
				that = this;
			
			rule = 'client[' + i + '][login]';
			validation.rules[rule] = {
				minlength: 3,
				maxlength: 64,
				required: function(element){
					if(i == 0) {
						return true;
					}
					return that.element.find("input[name='client[" + i + "][email]']").val().length > 0;
				}
			};
			validation.messages[rule] = {
				minlength: 'Минимальное количество символов - 3',
				maxlength: 'Максимальное количество символов - 64',
				required: required_message
			};
		},

		validate_email: function(validation, i) {
			var required_message = 'Это обязательное поле',
				that = this;
			
			rule = 'client[' + i + '][email]';
			validation.rules[rule] = {
				minlength: 3,
				maxlength: 64,
				email: true,
				required: function(element){
					if(i == 0) {
						return true;
					}
					return that.element.find("input[name='client[" + i + "][login]']").val().length > 0;
				}
			};
			validation.messages[rule] = {
				minlength: 'Минимальное количество символов - 3',
				maxlength: 'Максимальное количество символов - 64',
				email: 'Некорректно указан E-mail. Попробуйте еще раз.',
				required: required_message
			};
		},

		invite_validate: function(form) {
			var	validation = {rules: {}, messages: {}},
				rule,
				invite_items = this.element.find('.client_block'),
				i;
			
			for(i = invite_items.length; i--;) {
				this.validate_login(validation, i);
			}
			
			for(i = invite_items.length; i--;) {
				this.validate_email(validation, i);
			}
			
			validation.ignore = [];
			
			form.validate(validation);
		}
	}
);

new Invite_controller('#success');

// $('.message').easyModal({
	// autoOpen: true,
	// overlayOpacity: 0.9,
	// overlayColor: "#ffffff",
	// onClose: function(myModal) {
		// _gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
		// _gaq.push(['_trackEvent', 'closeerror', 'click']);
	// }
// });