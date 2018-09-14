defmodule Travenger.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add(:notification_object_id, references(:notification_objects))
      add(:notifier_id, references(:users))
      timestamps()
    end
  end
end
