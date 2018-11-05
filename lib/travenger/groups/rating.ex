defmodule Travenger.Groups.Rating do
  @moduledoc """
  Rating schema under groups context
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  alias Travenger.Groups.Group

  schema "groups_ratings" do
    field(:rating, :integer)
    belongs_to(:author, User)
    belongs_to(:group, Group)

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:rating])
    |> cast_assoc(:author, required: true)
    |> cast_assoc(:group, required: true)
    |> validate_required([:rating])
    |> validate_inclusion(:rating, 1..5)
  end
end
