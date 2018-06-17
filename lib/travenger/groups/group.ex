defmodule Travenger.Groups.Group do
  use Ecto.Schema

  import Ecto.Changeset

  alias Travenger.Posts.Event

  schema "groups" do
    field(:name, :string)
    field(:image_url, :string)

    has_many(:events, Event)
    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
