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

  schema "users_groups" do
    field(:role, UserRoleEnum, default: :waiting)

    belongs_to(:user, User)
    belongs_to(:group, Group)
    has_one(:membership_status, MembershipStatus)
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
    |> no_assoc_constraint(
      :membership_status,
      message: "Member is already associated to this group"
    )
    |> put_membership_status()
  end

  def approve_changeset(membership) do
    membership
    |> change()
    |> put_change(:role, :member)
  end

  defp put_membership_status(ch) do
    put_assoc(ch, :membership_status, %MembershipStatus{
      status: :pending,
      joined_at: DateTime.utc_now()
    })
  end
end
