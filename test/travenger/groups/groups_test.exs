defmodule Travenger.GroupsTest do
  use Travenger.DataCase

  import Travenger.Factory

  alias Travenger.Groups

  setup do
    %{user: insert(:user)}
  end

  describe "create_group/1" do
    setup %{user: user} do
      {:ok, group} = Groups.create_group(user, params_for(:group))

      %{group: group, user: user}
    end

    test "returns a created group", %{group: group} do
      assert group.id
      assert group.name
      assert group.image_url
      assert group.description
    end

    test "creates a member with role creator", %{group: group, user: user} do
      [head | _] = group.members
      assert head.role == :creator
      assert head.user_id == user.id
    end
  end

  describe "join_group/2" do
    setup %{user: user} do
      group = insert(:group)
      {:ok, user_group} = Groups.join_group(user, group)
      %{user_group: user_group}
    end

    test "returns a user group", %{user_group: user_group} do
      assert user_group.id
      assert user_group.user
      assert user_group.group
      assert user_group.role == :member
    end

    test "creates a pending membership status", %{user_group: user_group} do
      assert user_group.membership_status
      assert user_group.membership_status.status == :pending
      assert user_group.membership_status.joined_at
    end
  end

  describe "join_group/2 when member already have a membership to the group" do
    setup %{user: user} do
      group = insert(:group)

      insert(
        :user_group,
        group: group,
        user: user,
        membership_status: insert(:membership_status)
      )

      {:error, ch} = Groups.join_group(user, group)

      %{ch: ch}
    end

    test "returns an error", %{ch: ch} do
      assert ch.errors == [user_id_group_id: {"has already been taken", []}]
    end
  end
end
