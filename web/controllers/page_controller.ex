defmodule Hello.PageController do
  use Hello.Web, :controller
  alias Hello.Player

  def game(conn, _params) do
    player_id = get_session(conn, :player_id)
    if player_id do
      {:ok, json_players} = Poison.encode Repo.all Player
      player = Hello.Repo.get_by(Player, id: player_id)
      render conn, "game.html", player: player, json_players: json_players
    else
      conn
      |> put_flash(:error, "You must be logged in to do that")
      |> redirect(to: player_path(conn, :new))
    end
  end
end
