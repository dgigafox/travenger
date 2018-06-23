defmodule Travenger.Groups.Group do
  @moduledoc """
  Group schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Travenger.Accounts.{
    User,
    UserGroup
  }

  alias Travenger.Posts.Event

  schema "groups" do
    field(:name, :string)
    field(:image_url, :string)

    many_to_many(:users, User, join_through: UserGroup)
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
