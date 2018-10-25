defmodule Travenger.Accounts.MembershipTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Accounts.Membership

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch =
        %Membership{
          group: build(:group),
          user: build(:user)
        }
        |> Membership.changeset(%{role: :member})

      assert ch.valid?
    end

    test "returns invalid" do
      ch = Membership.changeset(%Membership{}, %{})

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
        %Membership{
          group: build(:group),
          user: build(:user)
        }
        |> Membership.join_changeset()

      assert ch.valid?
      assert ch.changes[:membership_status]
    end
  end

  describe "approve_changeset/1" do
    test "returns a valid changeset" do
      ch = Membership.approve_changeset(build(:membership))

      assert ch.valid?
      assert ch.changes[:role] == :member
    end
  end

  describe "invite_changeset/2" do
    test "returns a valid changeset" do
      ch =
        %Membership{
          group: build(:group),
          user: build(:user)
        }
        |> Membership.invite_changeset()

      assert ch.valid?
      assert ch.changes[:membership_status]
    end
  end

  describe "assign_admin_changeset/2" do
    test "returns a valid changeset" do
      membership = build(:membership, role: :member)
      ch = Membership.assign_admin_changeset(membership)

      assert ch.valid?
      assert ch.changes[:role] == :admin
    end

    test "returns invalid changeset if status is invalid" do
      membership = build(:membership, role: :waiting)
      ch = Membership.assign_admin_changeset(membership)

      refute ch.valid?
      assert ch.errors == [role: {"is invalid", []}]
    end
  end

  describe "remove_admin_changeset/2" do
    test "returns a valid changeset" do
      membership = build(:membership, role: :admin)
      ch = Membership.remove_admin_changeset(membership)

      assert ch.valid?
      assert ch.changes[:role] == :member
    end

    test "returns invalid change if status is invalid" do
      membership = build(:membership, role: :member)
      ch = Membership.remove_admin_changeset(membership)

      refute ch.valid?
      assert ch.errors == [role: {"is invalid", []}]
    end
  end
end
