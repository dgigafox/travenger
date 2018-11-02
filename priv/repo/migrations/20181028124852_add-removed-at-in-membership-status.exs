defmodule :"Elixir.Travenger.Repo.Migrations.Add-removed-at-in-membership-status" do
  use Ecto.Migration

  def change do
    alter table(:membership_statuses) do
      add(:removed_at, :naive_datetime)
    end
  end
end
