defmodule Hello.UserSocket do
  use Phoenix.Socket

  channel "game:lobby", Hello.GameChannel

  transport :websocket, Phoenix.Transports.WebSocket
  def connect(%{"token" => token}, socket) do
    {:ok, assign(socket, :uuid, UUID.uuid4)}
  end

  def id(_socket), do: nil
end
