defmodule Travenger.Repo.Migrations.ModifyGenderFieldInUsersTable do
  use Ecto.Migration

  def change do
    rename table(:users), :gender, to: :gender_string
    alter table(:users) do
      add(:gender, :integer)
    end
  end
end
