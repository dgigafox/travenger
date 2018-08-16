defmodule Travenger.Posts.Event do
  @moduledoc """
  Event schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.{
    Invitation,
    User
  }

  alias Travenger.Groups.Group

  schema "events" do
    field(:title, :string)

    belongs_to(:user, User)
    belongs_to(:group, Group)
    has_many(:invitations, Invitation)
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
