defmodule CommunityWeb.UserView do
  use CommunityWeb, :view

  alias Community.Accounts

  def name(%Accounts.User{username: username}) do
    username
    # |> String.split("@")
    # |> Enum.at(0)
  end
end
