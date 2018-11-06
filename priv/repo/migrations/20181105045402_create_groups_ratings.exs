defmodule Travenger.Repo.Migrations.CreateGroupsRatings do
  use Ecto.Migration

  def change do
    create table(:groups_ratings) do
      add(:rating, :integer)
      add(:author_id, references(:users))
      add(:group_id, references(:groups))
      timestamps()
    end

    create(index(:groups_ratings, [:author_id, :group_id], unique: true))
  end
end
