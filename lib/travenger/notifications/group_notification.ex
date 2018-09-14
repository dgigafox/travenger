defmodule Travenger.Notifications.GroupNotification do
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Groups.Group
  alias Travenger.Notifications.NotificationObject

  schema "groups_notifications" do
    belongs_to(:group, Group)
    belongs_to(:notification_object, NotificationObject)
    timestamps()
  end

  @doc false
  def changeset(group_notification, attrs \\ %{}) do
    group_notification
    |> cast(attrs, [])
    |> validate_required([])
  end
end
