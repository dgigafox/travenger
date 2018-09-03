defmodule :"Elixir.Travenger.Repo.Migrations.Add-unique-index-user-id-followed-user-id-in-followings-table" do
  use Ecto.Migration

  def change do
    create(index(:followings, [:user_id, :followed_user_id], unique: true))
  end
end
