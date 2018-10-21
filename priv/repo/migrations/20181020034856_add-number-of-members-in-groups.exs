defmodule :"Elixir.Travenger.Repo.Migrations.Add-number-of-members-in-groups" do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add(:member_limit, :integer)
    end
  end
end
