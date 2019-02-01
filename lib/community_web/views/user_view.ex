defmodule CommunityWeb.UserView do
  use CommunityWeb, :view

  alias Community.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end