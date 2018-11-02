defmodule Travenger.Groups.MembershipStatusTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Groups.MembershipStatus

  describe "changeset/2" do
    test "returns valid changeset" do
      status = build(:membership_status)
      ch = MembershipStatus.changeset(status, %{status: :approved})

      assert ch.valid?
      assert ch.changes[:status] == :approved
    end
  end

  describe "approve_changeset/2" do
    test "returns valid changeset" do
      status = build(:membership_status)
      ch = MembershipStatus.approve_changeset(status)

      assert ch.valid?
      assert ch.changes[:status] == :approved
      assert ch.changes[:approved_at]
    end
  end

  describe "remove_changeset/1" do
    test "returns valid changeset" do
      status = build(:membership_status)
      ch = MembershipStatus.remove_changeset(status)

      assert ch.valid?
      assert ch.changes[:status] == :removed
      assert ch.changes[:removed_at]
    end
  end
end
