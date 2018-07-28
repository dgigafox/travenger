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

    test "creates an approved membership status", %{group: group} do
      [head | _] = group.members
      assert head.membership_status.status == :approved
      assert head.membership_status.approved_at
    end
  end

  describe "join_group/2" do
    setup %{user: user} do
      group = insert(:group)
      {:ok, membership} = Groups.join_group(user, group)
      %{membership: membership}
    end

    test "returns a user group", %{membership: membership} do
      assert membership.id
      assert membership.user
      assert membership.group
      assert membership.role == :waiting
    end

    test "creates a pending membership status", %{membership: membership} do
      assert membership.membership_status
      assert membership.membership_status.status == :pending
      assert membership.membership_status.joined_at
    end
  end

  describe "join_group/2 when member already have a membership to the group" do
    setup %{user: user} do
      group = insert(:group)

      insert(
        :membership,
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

  describe "approve_join_request/1" do
    setup do
      membership = insert(:membership)
      {:ok, membership} = Groups.approve_join_request(membership)

      %{membership: membership}
    end

    test "approves a pending group membership request", %{membership: membership} do
      assert membership.id
      assert membership.role == :member
      assert membership.membership_status.status == :approved
      assert membership.membership_status.approved_at
    end
  end

  describe "update_group/2" do
    setup do
      group = insert(:group)

      params = %{
        name: "New Group Name",
        image_url: "http://website.com/new_image.png",
        description: "new description"
      }

      {:ok, group} = Groups.update_group(group, params)

      %{group: group, params: params}
    end

    test "updates a group", %{group: group, params: params} do
      assert group.name == params.name
      assert group.image_url == params.image_url
      assert group.description == params.description
    end
  end

  describe "list_groups/1" do
    setup %{user: user} do
      group = insert(:group, user: user)
      insert(:group)

      %{group: group}
    end

    test "list all groups" do
      %{total_entries: total} = Groups.list_groups()

      assert total == 2
    end

    test "filter by creator", %{user: user} do
      params = %{user_id: user.id}
      %{entries: groups} = Groups.list_groups(params)

      refute groups == []
      assert Enum.all?(groups, fn group -> group.user_id == user.id end)
    end
  end
end
