defmodule Hello.PageController do
  use Hello.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", person: random_stuff
  end

  def random_stuff do
    "The world"
  end
end
