defmodule Travenger.AccountsTest do
  use Travenger.DataCase

  import Travenger.Factory
  alias Travenger.Accounts

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
end
