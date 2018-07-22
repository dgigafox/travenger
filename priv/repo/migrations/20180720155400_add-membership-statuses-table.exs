defmodule :"Elixir.Travenger.Repo.Migrations.Add-membership-statuses-table" do
  use Ecto.Migration

  def change do
    create table(:membership_statuses) do
      add(:membership_id, references(:memberships))
      add(:status, :integer)
      add(:approved_at, :naive_datetime)
      add(:banned_at, :naive_datetime)
      add(:invited_at, :naive_datetime)
      add(:joined_at, :naive_datetime)
      add(:unbanned_at, :naive_datetime)
      add(:accepted_at, :naive_datetime)

      timestamps()
    end

    alter table(:memberships) do
      add(:membership_status_id, references(:membership_statuses))
    end
  end
end
