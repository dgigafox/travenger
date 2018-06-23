defmodule Travenger.Repo.Migrations.AssocGroupToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add(:group_id, references(:groups))
    end
  end
end
