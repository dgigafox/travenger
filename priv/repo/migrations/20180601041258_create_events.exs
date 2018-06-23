defmodule Travenger.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :user_id, references(:users)
      add :group_id, references(:groups)

      timestamps()
    end

  end
end
