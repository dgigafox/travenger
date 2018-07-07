defmodule Travenger.Repo.Migrations.UpdateGroupsTable do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add(:image_url, :string)
      add(:description, :text)
    end
  end
end
