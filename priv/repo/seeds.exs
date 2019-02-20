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

alias Community.{Accounts, Members}

user1_params = %{
  "username" => "test1",
  "credential" => %{email: "test1@example.com", password: "qwerty123"}
}

user2_params = %{
  "username" => "test2",
  "credential" => %{email: "test2@example.com", password: "qwerty123"}
}

user3_params = %{
  "username" => "test3",
  "credential" => %{email: "test3@example.com", password: "qwerty123"}
}

user1_profile = %{
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

user2_profile = %{
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

{:ok, user1} = Accounts.register_user(user1_params)
{:ok, user2} = Accounts.register_user(user2_params)
{:ok, _user3} = Accounts.register_user(user3_params)

Members.update_profile(user1.profile, user1_profile)
Members.update_profile(user2.profile, user2_profile)

