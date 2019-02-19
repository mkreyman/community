defmodule CommunityWeb.ProfileController do
  use CommunityWeb, :controller

  alias Community.Members
  alias Community.Members.Profile

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    profile = Members.list_user_profile(current_user)
    render(conn, "index.html", profile: profile)
  end

  def new(conn, _params, current_user) do
    changeset = Members.change_profile(current_user, %Profile{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"profile" => profile_params}, current_user) do
    case Members.create_profile(current_user, profile_params) do
      {:ok, profile} ->
        conn
        |> put_flash(:info, "Profile created successfully.")
        |> redirect(to: Routes.profile_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    profile = Members.get_user_profile!(current_user, id)
    render(conn, "show.html", profile: profile)
  end

  def edit(conn, %{"id" => id}, current_user) do
    profile = Members.get_user_profile!(current_user, id)
    changeset = Members.change_profile(current_user, profile)
    render(conn, "edit.html", profile: profile, changeset: changeset)
  end

  def update(conn, %{"id" => id, "profile" => profile_params}, current_user) do
    profile = Members.get_user_profile!(current_user, id)

    case Members.update_profile(profile, profile_params) do
      {:ok, profile} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: Routes.profile_path(conn, :show, profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profile: profile, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    profile = Members.get_user_profile!(current_user, id)
    {:ok, _profile} = Members.delete_profile(profile)

    conn
    |> put_flash(:info, "Profile deleted successfully.")
    |> redirect(to: Routes.profile_path(conn, :index))
  end
end
