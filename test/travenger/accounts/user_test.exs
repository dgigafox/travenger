defmodule Travenger.Accounts.UserTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Accounts.User

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = User.changeset(build(:user))

      assert ch.valid?
    end

    test "returns invalid" do
      ch = User.changeset(%User{})

      refute ch.valid?
      assert ch.errors[:email]
      assert ch.errors[:image_url]
      assert ch.errors[:first_name]
      assert ch.errors[:last_name]
      assert ch.errors[:gender]
    end
  end
end
