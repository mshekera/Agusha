if($('.thanks').length) {
	$('html, body').animate({
        scrollTop: 9999
    }, 1);
}

$('.message').easyModal({
	autoOpen: true,
	overlayOpacity: 0.9,
	overlayColor: "#ffffff",
	onClose: function(myModal) {
		_gaq.push(['_setReferrerOverride', referrer]);
		_gaq.push(['_trackEvent', 'closeerror', 'click']);
		_gaq.push(['_trackPageview'], url);
	}
});

$('.rules').click(function(ev) {
	_gaq.push(['_setReferrerOverride', referrer]);
	_gaq.push(['_trackEvent', 'rules', 'click']);
	_gaq.push(['_trackPageview'], url);
});

$('#registration_form').submit(function(ev) {
	var form = $(this);
	registration_validate(form);
	
	if(form.valid() == true) {
		_gaq.push(['_setReferrerOverride', referrer]);
		_gaq.push(['_trackEvent', 'registration', 'click']);
		_gaq.push(['_trackPageview'], url);
		
		return true;
	} else {
		return false;
	}
});

var registration_validate = function(form) {
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
};