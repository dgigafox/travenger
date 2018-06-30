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
      found_user = Accounts.find_user(%{
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
end
