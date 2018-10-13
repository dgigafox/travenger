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

      assert ch.errors == [
               user: {"can't be blank", [validation: :required]},
               name: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "update_changeset/2" do
    test "returns a valid changeset" do
      attrs = %{
        image_url: "http://website.com/new_image.png",
        description: "new description"
      }

      ch = Group.update_changeset(build(:group), attrs)

      assert ch.valid?
    end
  end

  describe "delete_changeset/2" do
    test "returns a valid changeset" do
      ch = Group.delete_changeset(build(:group))

      assert ch.valid?
      assert ch.changes[:deleted_at]
    end
  end
end
