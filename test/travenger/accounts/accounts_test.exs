defmodule Travenger.AccountsTest do
  use Travenger.DataCase

  import Travenger.Factory
  import Travenger.Helpers.Queries

  alias Travenger.Accounts
  alias Travenger.Groups.Membership

  @invalid_invitation_error "invalid invitation"
  @no_membership_error "no membership found"
  @assoc_user_error "invalid follower"
  @assoc_followed_user_error "invalid followed user"
  @follow_user_params_error "invalid params"
  @already_followed_error [user_id_followed_user_id: {"has already been taken", []}]
  @same_user_error "followed user is the same with the follower"
  @maximum_members_error "maximum number of members reached"

  describe "auth_or_register_users/1" do
    test "creates new user if user does not exist" do
      {:ok, user} = Accounts.auth_or_register_user(params_for(:user))

      assert user
    end

    test "updates user if user already exists" do
      user = insert(:user)
      {:ok, updated_user} = Accounts.auth_or_register_user(%{email: user.email})

      assert updated_user
      assert user.id == updated_user.id
    end
  end

  describe "find_membership/1" do
    setup do
      %{membership: insert(:membership)}
    end

    test "find membership by user_id", context do
      user = get_assoc(context.membership, :user)
      membership = Accounts.find_membership(%{user_id: user.id})

      assert membership.id == context.membership.id
    end

    test "find membership by group_id", context do
      group = get_assoc(context.membership, :group)
      membership = Accounts.find_membership(%{group_id: group.id})

      assert membership.id == context.membership.id
    end

    test "find membership by roles", context do
      membership =
        Accounts.find_membership(%{
          roles: [context.membership.role]
        })

      assert membership.role == context.membership.role
    end
  end

  describe "find_user/1" do
    setup do
      %{user: insert(:user)}
    end

    test "find user by id", %{user: user} do
      found_user = Accounts.find_user(%{id: user.id})

      assert found_user.id == user.id
    end

    test "find user by email", %{user: user} do
      found_user = Accounts.find_user(%{email: user.email})

      assert found_user.email == user.email
    end

    test "find user by id and name", %{user: user} do
      found_user =
        Accounts.find_user(%{
          id: user.id,
          name: user.name
        })

      assert found_user.id == user.id
      assert found_user.name == user.name
    end

    test "returns nil if user does not exist" do
      found_user = Accounts.find_user(%{id: 10_000})

      assert found_user == nil
    end
  end

  describe "get_user/1" do
    test "get user by id" do
      user = insert(:user)
      found_user = Accounts.get_user(user.id)

      assert found_user.id == user.id
    end
  end

  describe "list_users/1" do
    test "list users with pagination" do
      insert(:user)
      insert(:user)
      %{entries: list, total_entries: total} = Accounts.list_users()

      refute list == []
      assert total == 2
    end

    test "filter by gender" do
      insert(:user, gender: :male)
      insert(:user, gender: :female)
      params = %{gender: :male}
      %{entries: list, total_entries: total} = Accounts.list_users(params)

      refute list == []
      assert total == 1
    end

    test "filter by keyword to search by name" do
      name = "Darren Gegantino"
      insert(:user, name: name)

      %{entries: list, total_entries: total} =
        Accounts.list_users(%{
          search: "geg"
        })

      refute list == []
      assert total == 1
    end
  end

  describe "list_invitations/1" do
    setup do
      user = insert(:user)
      group = insert(:group)

      invitation =
        insert(:invitation, %{
          user: user,
          group: group,
          status: :pending
        })

      params = %{
        group_id: group.id,
        user_id: user.id,
        type: invitation.type,
        status: :pending
      }

      %{params: params}
    end

    test "returns a list of invitations" do
      %{entries: entries} = Accounts.list_invitations()

      refute entries == []
    end

    test "filter by user", %{params: params} do
      %{entries: invitations} = Accounts.list_invitations(params)

      refute invitations == []
      assert Enum.all?(invitations, fn i -> i.user_id == params.user_id end)
    end

    test "filter by group", %{params: params} do
      %{entries: invitations} = Accounts.list_invitations(params)

      refute invitations == []
      assert Enum.all?(invitations, fn i -> i.group_id == params.group_id end)
    end

    test "filter by type", %{params: params} do
      %{entries: invitations} = Accounts.list_invitations(params)

      refute invitations == []
      assert Enum.all?(invitations, fn i -> i.type == params.type end)
    end

    test "filter by status", %{params: params} do
      %{entries: invitations} = Accounts.list_invitations(params)

      refute invitations == []
      assert Enum.all?(invitations, fn i -> i.status == params.status end)
    end
  end

  describe "accept_invitation/1 for group" do
    setup do
      user = insert(:user)
      group = insert(:group)

      invitation =
        insert(:invitation, %{
          user: user,
          group: group,
          type: :group
        })

      insert(:membership, %{
        user: user,
        group: group,
        membership_status: %{status: :invited}
      })

      {:ok, invitation} = Accounts.accept_invitation(invitation)

      %{
        user: user,
        group: group,
        invitation: invitation
      }
    end

    test "should update invitation status to accepted", context do
      assert context.invitation.status == :accepted
    end

    test "should update membership to role member", context do
      membership =
        Membership
        |> where_user(%{user_id: context.user.id})
        |> where_group(%{group_id: context.group.id})
        |> Repo.one()

      assert membership.role == :member
    end

    test "should update membership status to accepted", context do
      membership_status =
        Membership
        |> where_user(%{user_id: context.user.id})
        |> where_group(%{group_id: context.group.id})
        |> Repo.one()
        |> get_assoc(:membership_status)

      assert membership_status.status == :accepted
      assert membership_status.accepted_at
    end

    test "returns error if invitation is invalid" do
      {:error, error} = Accounts.accept_invitation(nil)

      assert error == @invalid_invitation_error
    end
  end

  describe "accept_invitation/1 for group when maximum members reached" do
    test "returns error" do
      group = insert(:group, member_limit: 3)
      invitation = insert(:invitation, group: group, type: :group)

      insert_list(3, :membership, group: group, role: :member)

      insert(:membership, %{
        user: invitation.user,
        group: invitation.group,
        membership_status: %{status: :invited}
      })

      {:error, error} = Accounts.accept_invitation(invitation)

      assert error == @maximum_members_error
    end
  end

  describe "accept_invitation for group when no membership is found" do
    test "returns error" do
      invitation = insert(:invitation, %{type: :group})
      {:error, error} = Accounts.accept_invitation(invitation)

      assert error == @no_membership_error
    end
  end

  describe "follow user" do
    setup do
      follower = insert(:user)
      followed_user = insert(:user)

      %{follower: follower, followed_user: followed_user}
    end

    test "returns following record", c do
      {:ok, following} = Accounts.follow_user(c.follower, c.followed_user)

      assert following.id
      assert following.user_id == c.follower.id
      assert following.followed_user_id == c.followed_user.id
    end

    test "returns error when follower is nil", c do
      {:error, error} = Accounts.follow_user(nil, c.followed_user)
      assert error == @assoc_user_error
    end

    test "returns error when followed_user is nil", c do
      {:error, error} = Accounts.follow_user(c.follower, nil)
      assert error == @assoc_followed_user_error
    end

    test "returns error when follower and followed user are nil" do
      {:error, error} = Accounts.follow_user(nil, nil)
      assert error == @follow_user_params_error
    end

    test "returns error when user already followed another user", c do
      Accounts.follow_user(c.follower, c.followed_user)
      {:error, ch} = Accounts.follow_user(c.follower, c.followed_user)
      assert ch.errors == @already_followed_error
    end

    test "returns error when user follows himself", c do
      {:error, error} = Accounts.follow_user(c.follower, c.follower)
      assert error == @same_user_error
    end
  end

  defp get_assoc(struct, key) do
    struct
    |> Repo.preload([key])
    |> Map.get(key)
  end
end
