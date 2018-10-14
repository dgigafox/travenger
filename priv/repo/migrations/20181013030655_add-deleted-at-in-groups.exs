defmodule :"Elixir.Travenger.Repo.Migrations.Add-deleted-at-in-groups" do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add(:deleted_at, :naive_datetime)
    end
  end
end
