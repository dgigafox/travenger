defmodule Travenger.Posts.Event do
  use Ecto.Schema
  import Ecto.Changeset


  schema "events" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
