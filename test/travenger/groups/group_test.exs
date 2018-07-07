defmodule Travenger.Groups.GroupTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Groups.Group

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = Group.changeset(build(:group))

      assert ch.valid?
    end

    test "returns invalid" do
      ch = Group.changeset(%Group{})

      refute ch.valid?
      assert ch.errors == [name: {"can't be blank", [validation: :required]}]
    end
  end
end
