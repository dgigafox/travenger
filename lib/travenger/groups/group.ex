defmodule Travenger.Groups.Group do
  @moduledoc """
  Group schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Travenger.Accounts.{
    Invitation,
    Membership,
    User
  }

  alias Travenger.Groups.MembershipStatus
  alias Travenger.Posts.Event

  @group_attrs ~w(name image_url description member_limit)
  @default_limit 1_000

  schema "groups" do
    field(:name, :string)
    field(:image_url, :string)
    field(:description, :string)
    field(:member_limit, :integer, default: @default_limit)

    field(:deleted_at, :naive_datetime)

    belongs_to(:user, User)
    has_many(:members, Membership)
    has_many(:events, Event)
    has_many(:invitations, Invitation)
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

  def update_changeset(group, attrs) do
    group
    |> cast(attrs, @group_attrs)
    |> validate_member_limit()
  end

  def delete_changeset(group, attrs \\ %{}) do
    group
    |> cast(attrs, [])
    |> put_change(:deleted_at, DateTime.utc_now())
  end

  defp validate_member_limit(%{changes: %{member_limit: _limit}} = ch) do
    ch
    |> validate_number(:member_limit, greater_than_or_equal_to: 2)
    |> validate_number(:member_limit, less_than_or_equal_to: @default_limit)
  end

  defp validate_member_limit(ch), do: ch

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
