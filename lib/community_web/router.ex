defmodule CommunityWeb.Router do
  use CommunityWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CommunityWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", CommunityWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    pipe_through :authenticate_user
    resources "/profile", ProfileController, except: [:delete]
  end

  # scope "/manage", CommunityWeb do
  #   pipe_through [:browser, :authenticate_user]

  #   resources "/profile", ProfileController
  # end

  # Other scopes may use custom stacks.
  # scope "/api", CommunityWeb do
  #   pipe_through :api
  # end
end
