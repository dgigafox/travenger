defmodule Travenger.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string

      timestamps()
    end

  end
end
