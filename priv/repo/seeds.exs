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

alias Community.Repo
alias Community.{Accounts, Members}
alias Community.Members.{Address, UserAddress}

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

user1_address = %{
  country: "USA",
  locality: "Denver",
  region: "CO",
  po_box: nil,
  postal_code: "80211",
  street_address: "123 Main St",
  address_type: "business"
}

user2_address = %{
  country: "USA",
  locality: "Arvada",
  region: "CO",
  po_box: nil,
  postal_code: "80001",
  street_address: "456 W Curvey Cir",
  address_type: "residential"
}

user3_address = %{
  country: "Ukraine",
  locality: "Kiev",
  region: nil,
  po_box: "2111",
  postal_code: "365879",
  street_address: "111 Taras Bulba St",
  address_type: nil
}

{:ok, user1} = Accounts.register_user(user1_params)
{:ok, user2} = Accounts.register_user(user2_params)
{:ok, user3} = Accounts.register_user(user3_params)

Members.update_profile(user1.profile, user1_profile)
Members.update_profile(user2.profile, user2_profile)

# {:ok, address2} =
#   %Address{}
#   |> Address.changeset(user2_address)
#   |> Repo.insert()

# %UserAddress{}
# |> UserAddress.changeset(%{user_id: user1.id, address_id: address2.id})
# |> Repo.insert!()

Members.create_address(user1, user1_address)
Members.create_address(user2, user2_address)
Members.create_address(user3, user3_address)
