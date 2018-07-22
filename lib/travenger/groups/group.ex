defmodule Travenger.Groups.Group do
  @moduledoc """
  Group schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Travenger.Accounts.{
    Membership,
    User
  }

  alias Travenger.Groups.MembershipStatus
  alias Travenger.Posts.Event

  @group_attrs ~w(name image_url description)

  schema "groups" do
    field(:name, :string)
    field(:image_url, :string)
    field(:description, :string)

    belongs_to(:user, User)
    has_many(:members, Membership)
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
      %Membership{
        role: :creator,
        user: get_field(ch, :user),
        membership_status: %MembershipStatus{
          status: :approved,
          approved_at: DateTime.utc_now()
        }
      }
    ])
  end
end
