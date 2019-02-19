defmodule Community.Members do
  @moduledoc """
  The Members context.
  """

  import Ecto.Query, warn: false
  alias Community.Repo
  alias Community.Members.Profile
  alias Community.Accounts

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles do
    Profile
    |> Repo.all()
    |> preload_user()
  end

  def list_user_profile(%Accounts.User{} = user) do
    Profile
    |> user_profile_query(user)
    |> Repo.one!()
    |> preload_user()
  end

  def get_user_profile!(%Accounts.User{} = user, id) do
    from(p in Profile, where: p.id == ^id)
    |> user_profile_query(user)
    |> Repo.one!()
    |> preload_user()
  end

  defp user_profile_query(query, %Accounts.User{id: user_id}) do
    from(p in query, where: p.user_id == ^user_id)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: preload_user(Repo.get!(Profile, id))

  defp preload_user(profile) do 
    Repo.preload(profile, :user)
  end

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(%Accounts.User{} = user, attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> put_user(user)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{source: %Profile{}}

  """
  def change_profile(%Accounts.User{} = user, %Profile{} = profile) do
    profile
    |> Profile.changeset(%{})
    |> put_user(user)
  end

  defp put_user(changeset, user) do
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end
end
