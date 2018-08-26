defmodule Travenger.Accounts.Membership do
  @moduledoc """
  User Group association schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User

  alias Travenger.Groups.{
    Group,
    MembershipStatus
  }

  @required_attrs ~w(role)a
  @required_assoc ~w(user group)a

  @existing_assoc_error "Member is already associated to this group"

  schema "memberships" do
    field(:role, UserRoleEnum, default: :waiting)

    belongs_to(:user, User)
    belongs_to(:group, Group)
    has_one(:membership_status, MembershipStatus, on_replace: :update)
    timestamps()
  end

  def changeset(membership, attrs \\ %{}) do
    membership
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs ++ @required_assoc)
    |> unique_constraint(:user_id_group_id)
    |> assoc_constraint(:user)
    |> assoc_constraint(:group)
  end

  def join_changeset(membership, attrs \\ %{}) do
    membership
    |> changeset(attrs)
    |> no_assoc_constraint(:membership_status, message: @existing_assoc_error)
    |> put_membership_status()
  end

  def update_changeset(membership, attrs \\ %{}) do
    membership
    |> changeset(attrs)
    |> cast_assoc(:membership_status, required: true)
  end

  def approve_changeset(membership) do
    membership
    |> change()
    |> cast_assoc(:membership_status)
    |> put_change(:role, :member)
  end

  def invite_changeset(membership, attrs \\ %{}) do
    membership
    |> changeset(attrs)
    |> no_assoc_constraint(:membership_status, message: @existing_assoc_error)
    |> put_invited_status()
  end

  defp put_invited_status(ch) do
    put_assoc(ch, :membership_status, %MembershipStatus{
      status: :invited,
      invited_at: DateTime.utc_now()
    })
  end

  defp put_membership_status(ch) do
    put_assoc(ch, :membership_status, %MembershipStatus{
      status: :pending,
      joined_at: DateTime.utc_now()
    })
  end
end
