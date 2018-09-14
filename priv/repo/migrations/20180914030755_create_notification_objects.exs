defmodule Travenger.Repo.Migrations.CreateNotificationObjects do
  use Ecto.Migration

  def change do
    create table(:notification_objects) do
      add :entity_action, :integer

      timestamps()
    end

  end
end
