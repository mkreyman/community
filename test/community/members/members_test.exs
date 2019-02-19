defmodule Community.MembersTest do
  use Community.DataCase

  alias Community.Members

  describe "profiles" do
    alias Community.Members.Profile

    @valid_attrs %{
      additional_name: "some additional_name",
      alternative_name: "some alternative_name",
      alumni_of: "some alumni_of",
      birth_date: ~D[2010-04-17],
      birth_place: "some birth_place",
      death_date: ~D[2010-04-17],
      family_name: "some family_name",
      gender: "some gender",
      given_name: "some given_name",
      honorific_prefix: "some honorific_prefix",
      honorific_suffix: "some honorific_suffix",
      image: "some image",
      nationality: "some nationality"
    }
    @update_attrs %{
      additional_name: "some updated additional_name",
      alternative_name: "some updated alternative_name",
      alumni_of: "some updated alumni_of",
      birth_date: ~D[2011-05-18],
      birth_place: "some updated birth_place",
      death_date: ~D[2011-05-18],
      family_name: "some updated family_name",
      gender: "some updated gender",
      given_name: "some updated given_name",
      honorific_prefix: "some updated honorific_prefix",
      honorific_suffix: "some updated honorific_suffix",
      image: "some updated image",
      nationality: "some updated nationality"
    }
    @invalid_attrs %{
      additional_name: nil,
      alternative_name: nil,
      alumni_of: nil,
      birth_date: nil,
      birth_place: nil,
      death_date: nil,
      family_name: nil,
      gender: nil,
      given_name: nil,
      honorific_prefix: nil,
      honorific_suffix: nil,
      image: nil,
      nationality: nil
    }

    def profile_fixture(attrs \\ %{}) do
      {:ok, profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Members.create_profile()

      profile
    end

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Members.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Members.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      assert {:ok, %Profile{} = profile} = Members.create_profile(@valid_attrs)
      assert profile.additional_name == "some additional_name"
      assert profile.alternative_name == "some alternative_name"
      assert profile.alumni_of == "some alumni_of"
      assert profile.birth_date == ~D[2010-04-17]
      assert profile.birth_place == "some birth_place"
      assert profile.death_date == ~D[2010-04-17]
      assert profile.family_name == "some family_name"
      assert profile.gender == "some gender"
      assert profile.given_name == "some given_name"
      assert profile.honorific_prefix == "some honorific_prefix"
      assert profile.honorific_suffix == "some honorific_suffix"
      assert profile.image == "some image"
      assert profile.nationality == "some nationality"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Members.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{} = profile} = Members.update_profile(profile, @update_attrs)
      assert profile.additional_name == "some updated additional_name"
      assert profile.alternative_name == "some updated alternative_name"
      assert profile.alumni_of == "some updated alumni_of"
      assert profile.birth_date == ~D[2011-05-18]
      assert profile.birth_place == "some updated birth_place"
      assert profile.death_date == ~D[2011-05-18]
      assert profile.family_name == "some updated family_name"
      assert profile.gender == "some updated gender"
      assert profile.given_name == "some updated given_name"
      assert profile.honorific_prefix == "some updated honorific_prefix"
      assert profile.honorific_suffix == "some updated honorific_suffix"
      assert profile.image == "some updated image"
      assert profile.nationality == "some updated nationality"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Members.update_profile(profile, @invalid_attrs)
      assert profile == Members.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Members.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Members.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Members.change_profile(profile)
    end
  end
end
