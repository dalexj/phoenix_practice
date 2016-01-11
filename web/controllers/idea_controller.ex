defmodule Hello.IdeaController do
  use Hello.Web, :controller

  alias Hello.Idea

  plug :scrub_params, "idea" when action in [:create]

  def index(conn, _params) do
    idea = Idea.changeset(%Idea{})
    ideas = Repo.all(from i in Idea, order_by: [desc: i.score])
    render(conn, "index.html", ideas: ideas, idea: idea)
  end

  def upvote(conn, %{ "id" => id }) do
    vote_for_idea(id, 1)
    redirect conn, to: idea_path(conn, :index)
  end

  def downvote(conn, %{ "id" => id }) do
    vote_for_idea(id, -1)
    redirect conn, to: idea_path(conn, :index)
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

  def vote_for_idea(id, up_or_down) do
    idea = Repo.get!(Idea, id)
    changeset = Idea.changeset(idea, %{ "score" => idea.score + up_or_down })

    Repo.update(changeset)
  end
end
