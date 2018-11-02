defmodule :"Elixir.Travenger.Repo.Migrations.Add-group-assoc-to-followings" do
  use Ecto.Migration

  def change do
    alter table(:followings) do
      add(:followed_group_id, references(:groups))
    end

    create(index(:followings, [:user_id, :followed_group_id], unique: true))
  end
end
