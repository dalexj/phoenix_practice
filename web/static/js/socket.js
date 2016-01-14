// NOTE: The contents of this file will only be executed if
// you uncomment its entry in 'web/static/js/app.js'.

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in 'lib/my_app/endpoint.ex':
import { Socket } from 'deps/phoenix/web/static/js/phoenix'

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your 'web/router.ex':
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, 'user socket', current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in 'web/templates/layout/app.html.eex':
//
//     <script>window.userToken = '<%= assigns[:user_token] %>';</script>
//
// You will need to verify the user token in the 'connect/2' function
// in 'web/channels/user_socket.ex':
//
//     def connect(%{'token' => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, 'user socket', token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

function updateCanvas () {
  var canvas = $('#game-canvas')[0]
  var ctx = canvas.getContext('2d')
  ctx.fillStyle = '#d1d1d1'
  ctx.fillRect(0, 0, 500, 500)
  for (var i = 0; i < window.players.length; i++) {
    var player = window.players[i]
    ctx.fillStyle = player.color
    ctx.fillRect(player.x, player.y, 50, 50)
    ctx.fillStyle = '#ffffff'
    ctx.font = '12px monospace'
    ctx.textAlign = 'center'
    ctx.fillText(player.username, player.x + 25, player.y + 25)
  }
}

window.connectGame = function () {
  window.players = window.players || []
  updateCanvas()

  let socket = new Socket('/socket', {params: {token: window.userToken}})
  socket.connect()

  let channel = socket.channel('players:lobby', {})

  channel.on('player_update', payload => {
    for (var i = 0; i < window.players.length; i++) {
      if (window.players[i].username === payload.username) {
        window.players[i].x = payload.x
        window.players[i].y = payload.y
        updateCanvas()
        break
      }
    }

    console.log('player has moved', payload)
  })
  var username = ''
  channel.join()
    .receive('ok', resp => {
      console.log('Joined successfully', resp)
      username = resp
    })
    .receive('error', resp => { console.log('Unable to join', resp) })

  window.onkeydown = function (event) {
    var code = event.keyCode
    var left = 37
    var up = 38
    var right = 39
    var down = 40
    var location = {}
    for (var i = 0; i < window.players.length; i++) {
      if (window.players[i].username === username) {
        location = {x: window.players[i].x, y: window.players[i].y}
        break
      }
    }

    if (code === left) {
      location.x -= 10
    } else if (code === up) {
      location.y -= 10
    } else if (code === right) {
      location.x += 10
    } else if (code === down) {
      location.y += 10
    } else {
      return
    }
    channel.push('move', {location: location})
  }
}
