defmodule Travenger.Notifications.NotificationObject do
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Notifications.Notification

  schema "notification_objects" do
    field(:entity_action, EntityActionEnum)
    has_many(:notifications, Notification)
    timestamps()
  end

  @doc false
  def changeset(notification_object, attrs) do
    notification_object
    |> cast(attrs, [:entity_action])
    |> validate_required([:entity_action])
  end
end
