defmodule Travenger.Accounts.UserGroup do
  @moduledoc """
  User Group association schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  alias Travenger.Groups.Group

  @required_attrs ~w(role)a
  @required_assoc ~w(user group)a

  schema "users_groups" do
    field(:role, UserRoleEnum, default: :member)

    belongs_to(:user, User)
    belongs_to(:group, Group)
    timestamps()
  end

  def changeset(user_group, attrs \\ %{}) do
    user_group
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs ++ @required_assoc)
    |> assoc_constraint(:user)
    |> assoc_constraint(:group)
  end
end
