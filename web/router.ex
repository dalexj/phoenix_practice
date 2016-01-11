defmodule Hello.Router do
  use Hello.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", Hello do
    pipe_through :browser # Use the default browser stack

    get "/", IdeaController, :index
    resources "/ideas", IdeaController, only: [:index, :create]
    post "/ideas/:id/upvote", IdeaController, :upvote
    post "/ideas/:id/downvote", IdeaController, :downvote
  end

  # Other scopes may use custom stacks.
  # scope "/api", Hello do
  #   pipe_through :api
  # end
end
