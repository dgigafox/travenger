defmodule Travenger.Accounts.FollowingTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Accounts.Following

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = Following.changeset(build(:following))

      assert ch.valid?
    end

    test "returns invalid when type is missing" do
      ch = Following.changeset(%Following{})

      assert ch.errors == [
               followed_user: {"can't be blank", [validation: :required]},
               user: {"can't be blank", [validation: :required]}
             ]
    end
  end
end
