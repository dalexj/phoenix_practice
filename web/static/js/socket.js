/* jshint esnext:true */
import { Socket } from 'deps/phoenix/web/static/js/phoenix';

function updateCanvas () {
  var canvas = $('#game-canvas')[0];
  var ctx = canvas.getContext('2d');
  ctx.fillStyle = '#d1d1d1';
  ctx.fillRect(0, 0, 500, 500);
  for (var i = 0; i < window.players.length; i++) {
    var player = window.players[i];
    ctx.fillStyle = player.color;
    ctx.fillRect(player.x, player.y, 50, 50);
    ctx.fillStyle = '#ffffff';
    ctx.font = '12px monospace';
    ctx.textAlign = 'center';
    ctx.fillText(player.username, player.x + 25, player.y + 25);
  }
}

window.connectGame = function () {
  window.players = window.players || [];
  updateCanvas();

  let socket = new Socket('/socket', {params: {token: window.userToken}});
  socket.connect();

  let channel = socket.channel('players:lobby', {});

  channel.on('player_update', payload => {
    for (var i = 0; i < window.players.length; i++) {
      if (window.players[i].username === payload.username) {
        window.players[i].x = payload.x;
        window.players[i].y = payload.y;
        updateCanvas();
        break;
      }
    }

    console.log('player has moved', payload);
  });
  var username = '';
  channel.join()
    .receive('ok', resp => {
      console.log('Joined successfully', resp);
      username = resp;
    })
    .receive('error', resp => { console.log('Unable to join', resp); });

  window.onkeydown = function (event) {
    var code = event.keyCode;
    var left = 37;
    var up = 38;
    var right = 39;
    var down = 40;
    var location = {};
    for (var i = 0; i < window.players.length; i++) {
      if (window.players[i].username === username) {
        location = {x: window.players[i].x, y: window.players[i].y};
        break;
      }
    }

    if (code === left) {
      location.x -= 10;
    } else if (code === up) {
      location.y -= 10;
    } else if (code === right) {
      location.x += 10;
    } else if (code === down) {
      location.y += 10;
    } else {
      return;
    }
    channel.push('move', {location: location});
  };
};
