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
		_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
		_gaq.push(['_trackEvent', 'closeerror', 'click']);
	}
});

$('.rules').click(function(ev) {
	ev.preventDefault();
	var href = ev.target.href;
	
	_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
	_gaq.push(['_trackEvent', 'rules', 'click']);
	
	location.href = href;
});

$('#registration_form').submit(function(ev) {
	var form = $(this);
	registration_validate(form);
	
	if(form.valid() == true) {
		_gaq.push(['_setReferrerOverride', decodeURI(document.location.href)]);
		_gaq.push(['_trackEvent', 'registration', 'click']);
		
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