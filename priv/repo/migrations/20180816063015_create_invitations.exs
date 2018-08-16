defmodule Travenger.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add(:status, :integer)
      add(:type, :integer)
      add(:user_id, references(:users))
      add(:group_id, references(:groups))
      add(:event_id, references(:events))

      timestamps()
    end
  end
end
