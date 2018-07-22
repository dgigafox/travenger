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
end
