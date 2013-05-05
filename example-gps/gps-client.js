function createWebSocket(path) {
    var host = window.location.hostname;
    if(host == '') host = 'localhost';
    var uri = 'ws://' + host + ':9160' + path;

    var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
    return new Socket(uri);
}

var users = [];


function onMessage(event) {
    var p = $(document.createElement('p')).text(event.data);

    $('#messages').append(p);
    $('#messages').animate({scrollTop: $('#messages')[0].scrollHeight});
}

$(document).ready(function () {
    $('#join-form').submit(function () {
        $('#warnings').html('');
        var user = $('#user').val();
        var ws = createWebSocket('/');

        ws.onmessage = function(event) {
			$('#join-section').hide();
			$('#chat-section').show();
			$('#users-section').show();

			ws.onmessage = onMessage;
        };

        $('#join').append('Connecting...');

        return false;
    });
});
