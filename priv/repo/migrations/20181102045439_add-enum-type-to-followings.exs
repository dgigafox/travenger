defmodule :"Elixir.Travenger.Repo.Migrations.Add-enum-type-to-followings" do
  use Ecto.Migration

  def change do
    alter table(:followings) do
      add(:type, :integer)
    end
  end
end
