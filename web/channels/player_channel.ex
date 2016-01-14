defmodule Hello.PlayerChannel do
  use Hello.Web, :channel
  alias Hello.Player

  def join("players:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket.assigns[:username], socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("move", payload, socket) do

    x = payload["location"]["x"]
    y = payload["location"]["y"]

    player = Repo.get(Player, socket.assigns.player_id)
    IO.puts inspect player
    player
      |> Ecto.Changeset.change(x: x, y: y)
      |> Repo.update

    broadcast! socket, "player_update", %{ x: x, y: y, username: socket.assigns.username }
    {:reply, {:ok, payload}, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
