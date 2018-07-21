defmodule :"Elixir.Travenger.Repo.Migrations.Add-unique-compound-index-to-users-groups-table" do
  use Ecto.Migration

  def change do
    create(index(:users_groups, [:user_id, :group_id], unique: true))
  end
end
