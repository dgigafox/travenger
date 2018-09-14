defmodule Travenger.NotificationsTest do
  use Travenger.DataCase

  import Travenger.Factory

  alias Travenger.Notifications

  alias Travenger.Notifications.{
    Notification,
    NotificationChange
  }

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

    test "creates a notification change", c do
      clauses = [
        notification_object_id: c.notif_obj.id,
        actor_id: c.user.id
      ]

      assert Repo.get_by(NotificationChange, clauses)
    end

    test "creates notification records with appropriate notifiers", c do
      ids = Enum.map(c.notifiers, &Map.get(&1, :id))

      notifications =
        Notification
        |> where([n], n.notifier_id in ^ids)
        |> Repo.all()

      refute notifications == []
    end
  end
end
