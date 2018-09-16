defmodule Travenger.NotificationsTest do
  use Travenger.DataCase

  import Travenger.Factory
  import Travenger.TestHelpers

  alias Travenger.Notifications

  describe "create_notification" do
    setup do
      entity = insert(:group)

      notifiers = insert_list(2, :user)

      user = insert(:user)
      entity_action = :create

      {:ok, notif_obj} =
        Notifications.create_notification(
          entity,
          entity_action,
          user,
          notifiers
        )

      %{
        notif_obj: notif_obj,
        entity_action: entity_action,
        notifiers: notifiers,
        user: user
      }
    end

    test "creates a notification object", c do
      assert c.notif_obj.entity_action == c.entity_action
    end

    test "embeds an entity map", c do
      assert c.notif_obj.entity
      assert c.notif_obj.entity.object_id
    end

    test "creates a notification change", c do
      notif_change = get_assoc(c.notif_obj, :notification_change)

      assert notif_change.notification_object_id == c.notif_obj.id
      assert notif_change.actor_id == c.user.id
    end

    test "creates notification records with appropriate notifiers", c do
      ids = Enum.map(c.notifiers, &Map.get(&1, :id))

      notifications = get_assoc(c.notif_obj, :notifications)

      refute notifications == []

      assert Enum.any?(notifications, &(Map.get(&1, :notifier_id) in ids))
    end
  end
end
