defmodule Travenger.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add(:user_id, references(:users))
      add(:group_id, references(:groups))
      timestamps()
    end
  end
end
