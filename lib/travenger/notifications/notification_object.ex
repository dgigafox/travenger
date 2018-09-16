defmodule Travenger.Notifications.NotificationObject do
  @moduledoc """
  Notification object schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Notifications.{
    Entity,
    Notification,
    NotificationChange
  }

  schema "notification_objects" do
    field(:entity_action, EntityActionEnum)

    embeds_one(:entity, Entity)

    has_one(:notification_change, NotificationChange)
    has_many(:notifications, Notification)

    timestamps()
  end

  @doc false
  def changeset(notification_object, attrs \\ %{}) do
    notification_object
    |> cast(attrs, [:entity_action])
    |> validate_required([:entity_action])
  end
end
