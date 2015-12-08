defmodule Hello.IdeaController do
  use Hello.Web, :controller

  alias Hello.Idea

  plug :scrub_params, "idea" when action in [:create]

  def index(conn, _params) do
    ideas = Repo.all(Idea)
    render(conn, "index.html", ideas: ideas)
  end

  def create(conn, %{"idea" => idea_params}) do
    changeset = Idea.changeset(%Idea{}, idea_params)

    case Repo.insert(changeset) do
      {:ok, _idea} ->
        conn
        |> put_flash(:info, "Idea created successfully.")
        |> redirect(to: idea_path(conn, :index))
      {:error, changeset} ->
        redirect conn, to: idea_path(conn, :index)
    end
  end
end
