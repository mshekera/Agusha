/*globals alert, confirm, moment */
$(function () {
    var momentFormat = 'DD/MM/YYYY HH:mm';
    var setPopovered = function () {
        $('.popovered').popover({
            delay: {
                show: 500,
                hide: 100
            },
            trigger: 'hover',
            html: true,
            container: 'body'
        });
    };

    var iCheckAgain = function () {
        $("input[type='checkbox']:not(.simple), input[type='radio']:not(.simple)").iCheck({
            checkboxClass: 'icheckbox_minimal',
            radioClass: 'iradio_minimal'
        });
    };

    var initComponents = function () {
        setPopovered();
        iCheckAgain();
    };

    initComponents();

    $(document).on('click', '.t-process', function () {
        var self = this,
            btn = $(self),
            opts = {
                id: btn.data('id')
            };

        btn.button('loading');
        $.post('clients/process', opts, function (response) {
            if (typeof response === 'string' || !response.result) {
                alert(response || "Произошла неизвестная ошибка.");
                return btn.button('reset');
            }

            if (response.result === 0) {
                alert('Клиент уже обработан!');
            }

            btn.parent().fadeOut().remove();
        });
    });

    $('#client_list').on('click', '.t-remove', function () {
        if (!confirm("Вы точно хотите удалить этого пользователя?")) {
            return;
        }

        var self = this,
            btn = $(self),
            opts = {
                id: btn.data('id')
            };

        btn.button('loading');
        $.post('clients/remove', opts, function (response) {
            if (typeof response.result === 'string' || !response.result) {
                alert(response.result || "Произошла неизвестная ошибка.");
                return btn.button('reset');
            }

            btn.parents('tr').fadeOut(300, function () {
                $(this).remove();
            });
        });
    });

    // $('#client_list')
    //     .on( 'order.dt', iCheckAgain )
    //     .on( 'search.dt', iCheckAgain )
    //     .on( 'page.dt', iCheckAgain )
    //     .dataTable({
    //         'iDisplayLength': 25,
    //         'aLengthMenu': [25,50,100]
    //     });

    $('#t-export-range').daterangepicker({
        timePicker: true,
        timePickerIncrement: 5,
        format: momentFormat,
        timePicker12Hour: true,
        startDate: moment().subtract('months', 1),
        endDate: moment(),
        maxDate: moment()
    });

    $('#t-export-range').val(moment().subtract('months', 1).format(momentFormat) + ' - ' + moment().format(momentFormat));

    $(document).on('ifToggled', '.t-status', function () {
        var opts = {
            status: this.checked,
            id: $(this).data('id')
        };

        $.post('clients/setStatus', opts, function (response) {
            if (response.result !== true) {
                var msg = response.result || "Произошла неизвестная ошибка.";
                msg += ' Состояние НЕ СОХРАНЕНО!';
                alert(msg);
            }
        });
    });

    var processPostResponse = function (response) {
        var i, len, u, realIndex, content, data, string = '';

        for (i = 0, len = response.clients.length; i < len; i++) {
            u = response.clients[i];
            realIndex = (response.page - 1) * response.limit + i + 1;
            content = "Имя: <span>" +
                u.lastName + ' ' + u.patronymic + ' ' + u.firstName +
                "</span><br/>Телефон: <span>" + u.phone +
                "</span><br/>Город: <span>" + (u.city ? u.city.name : '-')  +
                "</span><br/>Улица: <span>" + u.street +
                "</span><br/>Номер дома: <span>" + u.house +
                "</span><br/>Квартира: <span>" + u.apartment +
                "</span><br/>Индекс: <span>" + u.postIndex +
                "</span><br/><br/>IP-адрес: <span>" + u.ip_address + "</span>";

            data = '<tr data-id="' + u._id + '">' +
                '<td>' + realIndex + '</td>' +
                '<td class="popovered" data-toggle="popover" ' +
                'title="Детальная информация" placement="right" ' +
                'data-content="' + content + '"><span>' + u.login +
                '</span></td>' +
                '<td>' + u.email + '</td>' +
                '<td>' + u.created_at + '</td>' +
                '<td>' + u.activated_at + '</td>' +
                '<td>' + u.type + '</td>' +
                '<td>' + (u.invited_by ? u.invited_by.login : "-") + '</td>' +
                '<td>' + (u.active ? "Да" : "Нет") + '</td>' +
                '<td>' + '<input class="t-status" type="checkbox" data-id="' +
                u._id + '"' + (u.status ? ' checked' : '') + '/>' + '</td>' +
                '<td>';

            if (u.newClient) {
                data += '<div class=".dt-button"><button class="btn btn-primary t-process" ' +
                    'type="button" data-loading-text="Ждите..." data-id="' + u._id + '">' +
                    '<i class="glyphicon glyphicon-ok-circle"></i>' +
                    '<span> Обработать</span>' +
                    '</button>';
            }

            data += '<div class=".dt-button"><button class="btn btn-danger t-remove" ' +
                'type="button" data-loading-text="Ждите..." data-id="' + u._id + '">' +
                '<i class="glyphicon glyphicon-remove-circle"></i>' +
                '<span> Удалить</span>' +
                '</button>' +
                '</td>' + '</tr>';

            string += data;
        }

        $('#client_list tbody').empty().html(string);

        initComponents();
    };

    var processPostSearch = function (response) {
        var i, len, string, html = '';
        for (i = 1, len = Math.ceil(response.count / response.limit); i <= len; i++) {
            string = '<a data-page="' + i + '" href="#"';
            if (i === 1) {
                string += ' class="current-page"';
            }
            string += '><span class="t-page">' + i + '</span></a>';

            html += string;
        }

        $('.t-pages-wrap').html(html);

        processPostResponse(response);
    };

    var performSearch = function (empty) {
        var opts = {
            page: 1,
            string: (empty ? '' : $('#t-search').val() || '')
        };

        $.post('clients', opts, processPostSearch);
    };

    $('#t-search').on('keyup', function (ev) {
        if (ev.keyCode === 13) {
            performSearch();
        }
    });

    $('#t-show-all').on('click', function () {
        performSearch(true);
    });

    $('#t-do-search').on('click', function () {
        performSearch();
    });

    $(document).on('click', '.t-page', function (ev) {
        if ($(this).parent().hasClass('current-page')) {
            return;
        }

        ev.stopPropagation();
        ev.preventDefault();

        $('.t-page').parent().removeClass('current-page');
        $(this).parent().addClass('current-page');

        var opts = {
            page: $(this).parent().data('page')
        };

        $.post('clients', opts, processPostResponse);
    });

});