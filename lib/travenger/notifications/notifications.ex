defmodule Travenger.Notifications do
  @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Travenger.Repo

  alias Travenger.Accounts.User
  alias Travenger.Groups.Group

  alias Travenger.Notifications.{
    GroupNotification,
    Notification,
    NotificationChange,
    NotificationObject
  }

  def create_notification(entity, entity_action, user, notifiers) do
    Multi.new()
    |> Multi.insert(
      :notification_object,
      NotificationObject.changeset(%NotificationObject{}, %{
        entity_action: entity_action
      })
    )
    |> Multi.run(:entity, &insert_entity(&1, entity))
    |> Multi.run(:notification_change, &insert_notification_change(&1, user))
    |> Multi.run(:notifications, &insert_notifications(&1, notifiers))
    |> Repo.transaction()
    |> case do
      {:error, _ops, val, _ch} ->
        {:error, val}

      {:ok, %{notification_object: obj}} ->
        {:ok, obj}
    end
  end

  defp insert_entity(attrs, %Group{} = entity) do
    %GroupNotification{
      group: entity,
      notification_object: attrs.notification_object
    }
    |> GroupNotification.changeset()
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
end
