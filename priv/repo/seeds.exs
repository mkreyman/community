# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Community.Repo.insert!(%Community.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Plug.Conn
alias Community.{Accounts, Members}
alias CommunityWeb.UserController

user1_params = %{username: "test1", email: "test1@example.com", password: "qwerty123"}
user2_params = %{username: "test2", email: "test2@example.com", password: "qwerty123"}

# {:ok, user1} = UserController.create(%Plug.Conn{}, %{"user" => user1_params})
# {:ok, user2} = UserController.create(%Plug.Conn{}, %{"user" => user2_params})

{:ok, user1} = Accounts.register_user(user1_params)
{:ok, user2} = Accounts.register_user(user2_params)

profile1 = %{
  additional_name: nil,
  alternative_name: "One",
  alumni_of: "Major Evy League",
  birth_date: ~D[2000-01-01],
  birth_place: "Some town",
  family_name: "Testovich",
  gender: "M",
  given_name: "Test1",
  honorific_prefix: "Mr.",
  honorific_suffix: "Jr",
  image: "path/to/image1.jpg",
  nationality: "USA"
}

profile2 = %{
  additional_name: nil,
  alternative_name: "Two",
  alumni_of: "Small vacational school",
  birth_date: ~D[2000-12-31],
  birth_place: "Some other town",
  family_name: "Testovsky",
  gender: "F",
  given_name: "Test2",
  honorific_prefix: "Ms.",
  honorific_suffix: nil,
  image: "path/to/image2.jpg",
  nationality: "Poland"
}

Members.create_profile(user1, profile1)
Members.create_profile(user2, profile2)
