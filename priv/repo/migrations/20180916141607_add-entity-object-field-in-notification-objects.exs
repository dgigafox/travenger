defmodule :"Elixir.Travenger.Repo.Migrations.Add-entity-object-field-in-notification-objects" do
  use Ecto.Migration

  def change do
    alter table(:notification_objects) do
      add(:entity, :map)
    end
  end
end
