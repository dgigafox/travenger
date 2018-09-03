defmodule Travenger.Repo.Migrations.CreateFollowings do
  use Ecto.Migration

  def change do
    create table(:followings) do
      add(:user_id, references(:users))
      add(:followed_user_id, references(:users))
      timestamps()
    end
  end
end
