defmodule Travenger.Repo.Migrations.CreateGroupsNotifications do
  use Ecto.Migration

  def change do
    create table(:groups_notifications) do
      add(:group_id, references(:groups))
      add(:notification_object_id, references(:notification_objects))
      timestamps()
    end
  end
end
