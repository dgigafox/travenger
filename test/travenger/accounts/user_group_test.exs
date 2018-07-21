defmodule Travenger.Accounts.UserGroupTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Accounts.UserGroup

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch =
        %UserGroup{
          group: build(:group),
          user: build(:user)
        }
        |> UserGroup.changeset(%{role: :member})

      assert ch.valid?
    end

    test "returns invalid" do
      ch = UserGroup.changeset(%UserGroup{}, %{})

      refute ch.valid?

      assert ch.errors == [
               user: {"can't be blank", [validation: :required]},
               group: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "join_changeset/2" do
    test "returns a valid changeset" do
      ch =
        %UserGroup{
          group: build(:group),
          user: build(:user)
        }
        |> UserGroup.join_changeset()

      assert ch.valid?
      assert ch.changes[:membership_status]
    end
  end
end
