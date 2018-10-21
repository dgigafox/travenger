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
        description: "new description",
        member_limit: 102
      }

      ch = Group.update_changeset(build(:group), attrs)

      assert ch.valid?
    end

    test "returns invalid changeset when setting limit less than 2" do
      attrs = %{
        member_limit: 1
      }

      ch = Group.update_changeset(build(:group), attrs)

      assert ch.errors == [
               member_limit: {
                 "must be greater than or equal to %{number}",
                 [validation: :number, number: 2]
               }
             ]
    end

    test "returns invalid changeset when setting limit greater than default" do
      attrs = %{
        member_limit: 1001
      }

      ch = Group.update_changeset(build(:group), attrs)

      assert ch.errors == [
               member_limit: {
                 "must be less than or equal to %{number}",
                 [validation: :number, number: 1000]
               }
             ]
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
