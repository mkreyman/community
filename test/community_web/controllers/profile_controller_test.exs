defmodule CommunityWeb.ProfileControllerTest do
  use CommunityWeb.ConnCase

  alias Community.Members

  @create_attrs %{
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

  def fixture(:profile) do
    {:ok, profile} = Members.create_profile(@create_attrs)
    profile
  end

  describe "index" do
    test "lists all profiles", %{conn: conn} do
      conn = get(conn, Routes.profile_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Profiles"
    end
  end

  describe "new profile" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.profile_path(conn, :new))
      assert html_response(conn, 200) =~ "New Profile"
    end
  end

  describe "create profile" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.profile_path(conn, :create), profile: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.profile_path(conn, :show, id)

      conn = get(conn, Routes.profile_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Profile"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.profile_path(conn, :create), profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Profile"
    end
  end

  describe "edit profile" do
    setup [:create_profile]

    test "renders form for editing chosen profile", %{conn: conn, profile: profile} do
      conn = get(conn, Routes.profile_path(conn, :edit, profile))
      assert html_response(conn, 200) =~ "Edit Profile"
    end
  end

  describe "update profile" do
    setup [:create_profile]

    test "redirects when data is valid", %{conn: conn, profile: profile} do
      conn = put(conn, Routes.profile_path(conn, :update, profile), profile: @update_attrs)
      assert redirected_to(conn) == Routes.profile_path(conn, :show, profile)

      conn = get(conn, Routes.profile_path(conn, :show, profile))
      assert html_response(conn, 200) =~ "some updated additional_name"
    end

    test "renders errors when data is invalid", %{conn: conn, profile: profile} do
      conn = put(conn, Routes.profile_path(conn, :update, profile), profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Profile"
    end
  end

  describe "delete profile" do
    setup [:create_profile]

    test "deletes chosen profile", %{conn: conn, profile: profile} do
      conn = delete(conn, Routes.profile_path(conn, :delete, profile))
      assert redirected_to(conn) == Routes.profile_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.profile_path(conn, :show, profile))
      end
    end
  end

  defp create_profile(_) do
    profile = fixture(:profile)
    {:ok, profile: profile}
  end
end
