defmodule Community.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :additional_name, :string
      add :alternative_name, :string
      add :alumni_of, :string
      add :birth_date, :date
      add :birth_place, :string
      add :family_name, :string
      add :gender, :string
      add :given_name, :string
      add :honorific_prefix, :string
      add :honorific_suffix, :string
      add :image, :string
      add :nationality, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:profiles, [:user_id])
  end
end
