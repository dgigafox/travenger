defmodule Travenger.Accounts.FollowingTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Accounts.Following

  describe "changeset/2" do
    test "returns a valid changeset for type user" do
      user = build(:user)
      following = build(:following, followed_user: user, type: :user)
      ch = Following.changeset(following)

      assert ch.valid?
    end

    test "returns a valid changeset for type group" do
      group = build(:group)
      following = build(:following, followed_group: group, type: :group)
      ch = Following.changeset(following)

      assert ch.valid?
    end

    test "returns invalid when type is missing" do
      ch = Following.changeset(%Following{})

      expected_errors = [
        type: {"can't be blank", [validation: :required]},
        user: {"can't be blank", [validation: :required]}
      ]

      assert ch.errors == expected_errors
    end

    test "returns invalid when assoc followed_user is missing" do
      user = build(:user)
      ch = Following.changeset(%Following{user: user}, %{type: :user})

      expected_errors = [
        followed_user: {"can't be blank", [validation: :required]}
      ]

      assert ch.errors == expected_errors
    end

    test "returnes invalid when assoc followed_group is missing" do
      user = build(:user)
      ch = Following.changeset(%Following{user: user}, %{type: :group})

      expected_errors = [
        followed_group: {"can't be blank", [validation: :required]}
      ]

      assert ch.errors == expected_errors
    end
  end
end
