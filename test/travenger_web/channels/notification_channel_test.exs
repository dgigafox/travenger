defmodule TravengerWeb.NotificationChannelTest do
  @moduledoc """
  Notification channel test
  """
  use TravengerWeb.ChannelCase

  import Travenger.Factory

  alias TravengerWeb.NotificationChannel

  @unauthorized_error "User unauthorized"

  describe "connection to socket" do
    setup do
      user = insert(:user)

      {:ok, _params, socket} =
        socket("", %{user: user})
        |> subscribe_and_join(NotificationChannel, "notifications:#{user.id}")

      %{socket: socket}
    end

    test "returns a socket", c do
      assert c.socket
      leave(c.socket)
    end
  end

  describe "connecting to socket with invalid id" do
    setup do
      user = insert(:user)

      {:error, error} =
        socket("", %{user: user})
        |> subscribe_and_join(NotificationChannel, "notifications:9999")

      %{error: error}
    end

    test "returns User unauthorized", c do
      assert c.error == @unauthorized_error
    end
  end
end
