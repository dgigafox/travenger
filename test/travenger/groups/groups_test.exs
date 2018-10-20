defmodule Travenger.GroupsTest do
  use Travenger.DataCase

  import Ecto.Query
  import Travenger.Factory

  alias Travenger.Accounts.Invitation
  alias Travenger.Groups

  @member_limit_error "cannot set limit less than current number of members"

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

  describe "invite/2" do
    setup %{user: user} do
      group = insert(:group)
      {:ok, membership} = Groups.invite(user, group)

      %{
        membership: membership,
        group: group,
        user: user
      }
    end

    test "returns a membership", %{membership: membership} do
      assert membership.id
      assert membership.user
      assert membership.group
      assert membership.role == :waiting
    end

    test "creates an invited membership status", %{membership: membership} do
      assert membership.membership_status
      assert membership.membership_status.status == :invited
      assert membership.membership_status.invited_at
    end

    test "creates an invitation", %{user: user, group: group} do
      assert Invitation
             |> where([i], i.user_id == ^user.id)
             |> where([i], i.group_id == ^group.id)
             |> where([i], i.type == ^:group)
             |> where([i], i.status == ^:pending)
             |> Repo.one()
    end
  end

  describe "invite/2 with existing invitation" do
    test "returns error", %{user: user} do
      group = insert(:group)

      invitation =
        insert(:invitation, %{
          user: user,
          group: group,
          status: :declined
        })

      {:error, error} = Groups.invite(user, group)
      assert error == "has #{invitation.status} invitation"
    end
  end

  describe "invite/2 with invalid params" do
    test "returns error with invalid user" do
      {:error, error} = Groups.invite(nil, insert(:group))
      assert error == "invalid user"
    end

    test "returns error with invalid group" do
      {:error, error} = Groups.invite(insert(:user), nil)
      assert error == "invalid group"
    end

    test "returns error when both user and group are invalid" do
      {:error, error} = Groups.invite(nil, nil)
      assert error == "invalid user and group"
    end
  end

  describe "invite/2 when member already have a membership to the group" do
    setup %{user: user} do
      group = insert(:group)

      insert(
        :membership,
        group: group,
        user: user,
        membership_status: insert(:membership_status)
      )

      {:error, ch} = Groups.invite(user, group)

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
        description: "new description",
        member_limit: 8
      }

      {:ok, group} = Groups.update_group(group, params)

      %{group: group, params: params}
    end

    test "updates a group", %{group: group, params: params} do
      assert group.name == params.name
      assert group.image_url == params.image_url
      assert group.description == params.description
      assert group.member_limit == params.member_limit
    end
  end

  describe "update_group/2 setting member limit less than current member count" do
    test "returns error" do
      group = insert(:group)
      insert_list(4, :membership, group: group)

      params = %{member_limit: 3}

      {:error, error} = Groups.update_group(group, params)

      assert error == @member_limit_error
    end
  end

  describe "list_groups/1" do
    setup %{user: user} do
      group = insert(:group, user: user, name: "Sample Travel Group")
      insert(:group, deleted_at: DateTime.utc_now())
      insert(:group)

      %{group: group}
    end

    test "list all groups" do
      %{total_entries: total} = Groups.list_groups()

      assert total == 2
    end

    test "list all groups excluding deleted_at" do
      %{entries: entries} = Groups.list_groups()

      assert Enum.all?(entries, &is_nil(&1.deleted_at))
    end

    test "filter by creator", %{user: user} do
      params = %{user_id: user.id}
      %{entries: groups} = Groups.list_groups(params)

      refute groups == []
      assert Enum.all?(groups, fn group -> group.user_id == user.id end)
    end

    test "filter by name", %{group: grp} do
      params = %{name: grp.name}
      %{entries: groups} = Groups.list_groups(params)

      refute groups == []
      assert Enum.all?(groups, fn group -> group.name == grp.name end)
    end

    test "filter by keyword", %{group: grp} do
      params = %{search: "ple tra"}
      %{entries: groups} = Groups.list_groups(params)

      refute groups == []
      assert Enum.any?(groups, fn group -> group.name == grp.name end)
    end
  end

  describe "delete_group/1" do
    test "updates deleted_at" do
      group = insert(:group)
      {:ok, group} = Groups.delete_group(group)

      assert group.id
      refute is_nil(group.deleted_at)
    end
  end

  describe "get_group/1" do
    test "returns a group" do
      group = insert(:group)
      assert Groups.get_group(group.id)
    end

    test "does not return deleted group" do
      group = insert(:group, deleted_at: DateTime.utc_now())
      refute Groups.get_group(group.id)
    end
  end
end
