defmodule Travenger.Notifications do
  @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false
  import Travenger.Helpers.Queries.Notification
  import TravengerWeb.Endpoint

  alias Ecto.Multi
  alias Travenger.Repo

  alias Travenger.Accounts.User
  alias Travenger.Groups.Group

  alias Travenger.Notifications.{
    Notification,
    NotificationChange,
    NotificationObject
  }

  def list_notifications(params \\ %{}) do
    Notification
    |> preload(
      [n],
      notification_object: [
        :notifications,
        notification_change: [:actor]
      ]
    )
    |> where_notifier(params)
    |> Repo.paginate(params)
  end

  def create_notification(entity, entity_action, user, notifiers) do
    Multi.new()
    |> Multi.run(:notification_object, &create_obj(&1, entity, entity_action))
    |> Multi.run(:notification_change, &insert_notification_change(&1, user))
    |> Multi.run(:notifications, &insert_notifications(&1, notifiers))
    |> Multi.run(:sent_notifications, &send_notifications(&1))
    |> Repo.transaction()
    |> case do
      {:error, _ops, val, _ch} ->
        {:error, val}

      {:ok, %{notification_object: obj}} ->
        {:ok, obj}
    end
  end

  defp send_notifications(%{notifications: notifications}) do
    notifications
    |> Enum.map(&Repo.preload(&1, notification_object: [notification_change: [:actor]]))
    |> send_notification()

    {:ok, notifications}
  end

  defp send_notification([]), do: :ok

  defp send_notification([notification | notifications]) do
    Task.start(fn ->
      broadcast("notifications:#{notification.notifier_id}", "new", %{notification: notification})
    end)

    send_notification(notifications)
  end

  defp create_obj(_, %Group{} = group, action) do
    %NotificationObject{
      entity_action: action,
      entity: create_entity_map(group, :group)
    }
    |> NotificationObject.changeset()
    |> Repo.insert()
  end

  defp insert_notification_change(attrs, %User{} = actor) do
    %NotificationChange{
      notification_object: attrs.notification_object,
      actor: actor
    }
    |> NotificationChange.changeset()
    |> Repo.insert()
  end

  defp insert_notifications(attrs, notifiers) do
    entries =
      Enum.map(
        notifiers,
        &insert_notification(&1, attrs.notification_object)
      )

    {:ok,
     Notification
     |> Repo.insert_all(entries, returning: true)
     |> elem(1)}
  end

  defp insert_notification(notifier, notif_obj) do
    Map.new()
    |> Map.put(:notifier_id, notifier.id)
    |> Map.put(:notification_object_id, notif_obj.id)
    |> Map.put(:inserted_at, DateTime.utc_now())
    |> Map.put(:updated_at, DateTime.utc_now())
  end

  defp create_entity_map(entity, object_type) do
    Map.new()
    |> Map.put(:object_id, entity.id)
    |> Map.put(:name, entity.name)
    |> Map.put(:object_type, object_type)
  end
end
