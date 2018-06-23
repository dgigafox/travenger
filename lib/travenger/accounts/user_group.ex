defmodule Travenger.Accounts.UserGroup do
  @moduledoc """
  User Group association schema
  """
  use Ecto.Schema

  alias Travenger.Accounts.User
  alias Travenger.Groups.Group
  schema "users_groups" do
    belongs_to(:user, User)
    belongs_to(:group, Group)
    timestamps()
  end
end
