defmodule Travenger.Repo.Migrations.AddUserInfoToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:gender, :string)
    end
  end
end
