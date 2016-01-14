defmodule Hello.PlayerController do
  use Hello.Web, :controller

  alias Hello.Player

  def new(conn, _params) do
    render conn, "new.html", player: Player.changeset(%Player{})
  end

  def create(conn, %{"player" => player_params}) do
    changeset = Player.changeset(%Player{}, player_params)

    case Repo.insert(changeset) do
      {:ok, player} ->
        conn
          |> put_session(:player_id, player.id)
          |> redirect(to: page_path(conn, :game))
      {:error, changeset} ->
        redirect conn, to: player_path(conn, :new)
    end
  end

  def logout(conn, _params) do
    conn
      |> put_flash(:info, "Logged out successfully")
      |> put_session(:player_id, nil)
      |> redirect(to: player_path(conn, :new))
  end

  def login(conn, %{"player" => player_params}) do
    player = Hello.Repo.get_by(
      Hello.Player,
      username: player_params["username"],
      password: player_params["password"]
    )
    if player do
      conn
        |> put_session(:player_id, player.id)
        |> redirect(to: page_path(conn, :game))
    else
      conn
        |> put_flash(:error, "invalid username/password")
        |> redirect(to: player_path(conn, :new))
    end
  end

end
