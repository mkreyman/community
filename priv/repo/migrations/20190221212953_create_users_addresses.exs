defmodule Community.Repo.Migrations.CreateUsersAddresses do
  use Ecto.Migration

  def change do
    create table(:users_addresses) do
      add :user_id, references(:users, on_delete: :nothing)
      add :address_id, references(:addresses, on_delete: :nothing)

      timestamps()
    end

    create index(:users_addresses, [:user_id])
    create index(:users_addresses, [:address_id])
  end
end
