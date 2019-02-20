defmodule Community.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Community.Repo
  alias Community.Accounts.User
  # use Util.PipeDebug

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def get_user_by_email(email) do
    from(u in User, join: c in assoc(u, :credential), where: c.email == ^email)
    |> Repo.one()
    |> Repo.preload(:credential)
  end

  def authenticate_by_email_and_pass(email, given_pass) do
    user = get_user_by_email(email)

    cond do
      user && Comeonin.Pbkdf2.checkpw(given_pass, user.credential.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Comeonin.Pbkdf2.dummy_checkpw()
        {:error, :not_found}
    end
  end

  def list_users do
    Repo.all(User)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> User.profile_changeset(attrs |> Map.put("profile", %{}))
    |> Repo.insert()
  end

  # alias Community.Accounts.Credential

  # @doc """
  # Returns the list of credentials.

  # ## Examples

  #     iex> list_credentials()
  #     [%Credential{}, ...]

  # """
  # def list_credentials do
  #   Repo.all(Credential)
  # end

  # @doc """
  # Gets a single credential.

  # Raises `Ecto.NoResultsError` if the Credential does not exist.

  # ## Examples

  #     iex> get_credential!(123)
  #     %Credential{}

  #     iex> get_credential!(456)
  #     ** (Ecto.NoResultsError)

  # """
  # def get_credential!(id), do: Repo.get!(Credential, id)

  # @doc """
  # Creates a credential.

  # ## Examples

  #     iex> create_credential(%{field: value})
  #     {:ok, %Credential{}}

  #     iex> create_credential(%{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def create_credential(attrs \\ %{}) do
  #   %Credential{}
  #   |> Credential.changeset(attrs)
  #   |> Repo.insert()
  # end

  # @doc """
  # Updates a credential.

  # ## Examples

  #     iex> update_credential(credential, %{field: new_value})
  #     {:ok, %Credential{}}

  #     iex> update_credential(credential, %{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  # def update_credential(%Credential{} = credential, attrs) do
  #   credential
  #   |> Credential.changeset(attrs)
  #   |> Repo.update()
  # end

  # @doc """
  # Deletes a Credential.

  # ## Examples

  #     iex> delete_credential(credential)
  #     {:ok, %Credential{}}

  #     iex> delete_credential(credential)
  #     {:error, %Ecto.Changeset{}}

  # """
  # def delete_credential(%Credential{} = credential) do
  #   Repo.delete(credential)
  # end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking credential changes.

  # ## Examples

  #     iex> change_credential(credential)
  #     %Ecto.Changeset{source: %Credential{}}

  # """
  # def change_credential(%Credential{} = credential) do
  #   Credential.changeset(credential, %{})
  # end
end
