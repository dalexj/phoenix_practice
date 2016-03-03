defmodule Hello.PageController do
  use Hello.Web, :controller

  def game(conn, _params) do
    render conn, "game.html"
  end
end
