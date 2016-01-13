defmodule Hello.PageController do
  use Hello.Web, :controller

  def game(conn, _params) do
    player_id = get_session(conn, :player_id)
    if player_id do
      player = Hello.Repo.get_by(Hello.Player, id: player_id)
      render conn, "game.html", player: player
    else
      conn
      |> put_flash(:error, "You must be logged in to do that")
      |> redirect(to: player_path(conn, :new))
    end
  end
end
