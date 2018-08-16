defmodule Travenger.Accounts.InvitationTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Accounts.Invitation

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = Invitation.changeset(build(:invitation))

      assert ch.valid?
    end

    test "returns invalid when type is missing" do
      ch = Invitation.changeset(%Invitation{})

      assert ch.errors[:type] == {"can't be blank", [validation: :required]}
    end

    test "returns invalid when association is missing" do
      ch = Invitation.changeset(%Invitation{type: :event})

      assert ch.errors[:event] == {"can't be blank", [validation: :required]}
    end
  end
end
