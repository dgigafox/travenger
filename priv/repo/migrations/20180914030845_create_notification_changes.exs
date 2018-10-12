defmodule Travenger.Repo.Migrations.CreateNotificationChanges do
  use Ecto.Migration

  def change do
    create table(:notification_changes) do
      add(:notification_object_id, references(:notification_objects))
      add(:actor_id, references(:users))
      timestamps()
    end
  end
end
