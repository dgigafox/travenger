defmodule Travenger.Posts.Event do
  @moduledoc """
  Event schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  alias Travenger.Groups.Group
  schema "events" do
    field :title, :string

    belongs_to(:user, User)
    belongs_to(:group, Group)
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
