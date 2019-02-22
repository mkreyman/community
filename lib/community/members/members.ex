defmodule Community.Members do
  @moduledoc """
  The Members context.
  """

  import Ecto.Query, warn: false
  alias Community.Repo
  alias Community.Members.{Profile, Address, UserAddress}
  alias Community.Accounts.User
  # use Util.PipeDebug

  def create_address(%User{} = user, attrs \\ %{}) do
    with {:ok, address} <- %Address{} |> Address.changeset(attrs) |> Repo.insert() do
      %UserAddress{}
      |> UserAddress.changeset(%{user_id: user.id, address_id: address.id})
      |> Repo.insert()
    end
  end

  def list_addresses() do
    Address
    |> Repo.all()
    |> preload_user()
  end

  def list_user_addresses(%User{} = user) do
    UserAddress
    |> user_assoc_query(user)
    |> Repo.all()
    |> preload_address()
    |> Enum.map(fn user_address -> user_address.address end)
  end

  def find_address(%Address{} = address) do
    Address
    |> address_query(address)
    |> Repo.one()
  end

  def add_user_to_address(%User{} = user, %Address{} = address) do
    %UserAddress{}
    |> UserAddress.changeset(%{user_id: user.id, address_id: address.id})
    |> Repo.insert()
  end

  defp address_query(query, %Address{id: address_id}) do
    from(a in query, where: a.id == ^address_id)
  end

  defp preload_address(assoc) do
    Repo.preload(assoc, :address)
  end

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles() do
    Profile
    |> Repo.all()
    |> preload_user()
  end

  def list_user_profile(%User{} = user) do
    profile =
      Profile
      |> user_assoc_query(user)
      |> Repo.one()

    case profile do
      nil -> nil
      profile -> preload_user(profile)
    end
  end

  def get_user_profile(%User{} = user, id) do
    profile =
      from(p in Profile, where: p.id == ^id)
      |> user_assoc_query(user)
      |> Repo.one()

    case profile do
      nil -> nil
      profile -> preload_user(profile)
    end
  end

  defp user_assoc_query(query, %User{id: user_id}) do
    from(a in query, where: a.user_id == ^user_id)
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

  defp preload_user(assoc) do
    Repo.preload(assoc, :user)
  end

  defp preload_users(assoc) do
    Repo.preload(assoc, :users)
  end

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(%User{} = user, attrs \\ %{}) do
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
  def change_profile(%User{} = user, %Profile{} = profile) do
    profile
    |> Profile.changeset(%{})
    |> put_user(user)
  end

  defp put_user(changeset, user) do
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end
end
