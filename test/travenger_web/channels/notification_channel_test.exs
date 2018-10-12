defmodule TravengerWeb.NotificationChannelTest do
  @moduledoc """
  Notification channel test
  """
  use TravengerWeb.ChannelCase

  import Travenger.Factory

  alias Travenger.Notifications
  alias TravengerWeb.NotificationChannel

  @unauthorized_error "User unauthorized"

  describe "connection to socket" do
    setup do
      user = insert(:user)
      insert(:notification, notifier: user)

      {:ok, params, socket} =
        socket("", %{user: user})
        |> subscribe_and_join(NotificationChannel, "notifications:#{user.id}")

      %{params: params, socket: socket, user: user}
    end

    test "returns a socket", c do
      assert c.socket
      leave(c.socket)
    end

    test "returns a list of notifications", c do
      %{notifications: notifs} = c.params
      refute notifs == []
      assert Enum.all?(notifs, &(Map.get(&1, :notifier_id) == c.user.id))
      leave(c.socket)
    end

    test "broadcasts are pushed to the client", c do
      entity = insert(:group)

      notifiers = [c.user]

      user = insert(:user)
      entity_action = :create

      {:ok, _notif_obj} =
        Notifications.create_notification(
          entity,
          entity_action,
          user,
          notifiers
        )

      assert_broadcast("new", %{notification: _notification})
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
