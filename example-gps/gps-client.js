function createWebSocket(path) {
    var host = window.location.hostname;
    if(host == '') host = 'localhost';
    var uri = 'ws://' + host + ':9160' + path;

    var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
    return new Socket(uri);
}

var users = [];


function onMessage(websocket, map, event) {
    var locationString = event.data;
    var temp = locationString.split(" ");
    var latString = temp[0];
    var lonString = temp[1];
    var latLon = new google.maps.LatLng(latString, lonString);

    /*
    var p = $(document.createElement('p')).text(event.data);

    $('#messages').append(p);
    $('#messages').animate({scrollTop: $('#messages')[0].scrollHeight});
    */
    var marker = new google.maps.Marker({
        position: latLon,
        map: map,
        title: 'Hello World!',
        animation: google.maps.Animation.DROP,
    });

    var deleteMarkerFunc = (function () 
        {
            marker.setMap(null);
        });

    setTimeout(deleteMarkerFunc, 1000);
}

$(document).ready(function () {
    /*
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
    */
});


function initializeWebSocket (map) {
    var websocket = createWebSocket('/');
    websocket.onmessage = function(event) {
        onMessage(websocket, map, event);
    };
}
