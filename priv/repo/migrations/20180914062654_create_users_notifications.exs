defmodule Travenger.Repo.Migrations.CreateUsersNotifications do
  use Ecto.Migration

  def change do
    create table(:users_notifications) do
      add(:user_id, references(:users))
      add(:notification_object_id, references(:notification_objects))
      timestamps()
    end
  end
end
