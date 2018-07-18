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

  @group_attrs ~w(name image_url description)

  schema "groups" do
    field(:name, :string)
    field(:image_url, :string)
    field(:description, :string)

    # many_to_many(:users, User, join_through: UserGroup)'
    belongs_to(:user, User)
    has_many(:members, UserGroup)
    has_many(:events, Event)
    timestamps()
  end

  @doc false
  def changeset(group, attrs \\ %{}) do
    group
    |> cast(attrs, @group_attrs)
    |> validate_required([:name])
    |> validate_required([:user])
    |> assoc_constraint(:user)
    |> put_member()
  end

  defp put_member(ch) do
    put_assoc(ch, :members, [
      %UserGroup{
        role: :creator,
        user: get_field(ch, :user)
      }
    ])
  end
end
