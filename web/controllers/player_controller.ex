defmodule Hello.PlayerController do
  use Hello.Web, :controller

  alias Hello.Player

  def new(conn, _params) do
    render conn, "new.html", player: Player.changeset(%Player{})
  end

  def create(conn, %{"player" => player_params}) do
    changeset = Player.changeset(%Player{}, player_params)

    case Repo.insert(changeset) do
      {:ok, _player} ->
        conn
          |> put_flash(:info, "Player created successfully.")
          |> redirect(to: player_path(conn, :new)) # change this
      {:error, changeset} ->
        redirect conn, to: player_path(conn, :new)
    end
  end
end
