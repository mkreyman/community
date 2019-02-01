defmodule CommunityWeb.UserController do
  use CommunityWeb, :controller

  alias Community.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end
end