defmodule Hello.RoomChannel do
  use Phoenix.Channel

  def join("game:lobby", _message, socket) do
    send self, :after_join
    {:ok, socket}
  end

  def join("game:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info(:after_join, socket) do
    broadcast! socket, "user_join", %{}
    {:noreply, socket}
  end
end
