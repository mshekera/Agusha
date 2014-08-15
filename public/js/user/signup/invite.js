$('.message').easyModal({
	autoOpen: true,
	overlayOpacity: 0.9,
	overlayColor: "#ffffff",
	onClose: function(myModal) {
		_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
		_gaq.push(['_trackEvent', 'closeerror', 'click']);
	}
});

$('#add_client').on('click', function() {
	var client_block = $('.client_block');
	var template = $('#add_client_tmpl').html();
	var i = client_block.length;
	
	var html = _.template(template, {
		i: i
	});
	
	$('#client_container').append(html);
});

$('#invite_form').submit(function(ev) {
	var form = $(this);
	invite_validate(form);
	
	if(form.valid() == true) {
		_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
		_gaq.push(['_trackEvent', 'invite', 'click']);
		
		return true;
	} else {
		return false;
	}
});

var validate_login = function(validation, i) {
	var required_message = 'Это обязательное поле';
	
	rule = 'client[' + i + '][login]';
	validation.rules[rule] = {
		minlength: 3,
		maxlength: 64,
		required: function(element){
			if(i == 0) {
				return true;
			}
			return $("input[name='client[" + i + "][email]']").val().length > 0;
		}
	};
	validation.messages[rule] = {
		minlength: 'Минимальное количество символов - 3',
		maxlength: 'Максимальное количество символов - 64',
		required: required_message
	};
};

var validate_email = function(validation, i) {
	var required_message = 'Это обязательное поле';
	
	rule = 'client[' + i + '][email]';
	validation.rules[rule] = {
		minlength: 3,
		maxlength: 64,
		email: true,
		required: function(element){
			if(i == 0) {
				return true;
			}
			return $("input[name='client[" + i + "][login]']").val().length > 0;
		}
	};
	validation.messages[rule] = {
		minlength: 'Минимальное количество символов - 3',
		maxlength: 'Максимальное количество символов - 64',
		email: 'Некорректно указан E-mail. Попробуйте еще раз.',
		required: required_message
	};
};

var invite_validate = function(form) {
	var	validation = {rules: {}, messages: {}},
		rule,
		invite_items = $('.client_block'),
		i;
	
	for(i = invite_items.length; i--;) {
		validate_login(validation, i);
	}
	
	for(i = invite_items.length; i--;) {
		validate_email(validation, i);
	}
	
	validation.ignore = [];
	
	form.validate(validation);
};