defmodule :"Elixir.Travenger.Repo.Migrations.Add-user-assoc-to-groups" do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add(:user_id, references(:users))
    end
  end
end
