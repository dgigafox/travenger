defmodule Travenger.Notifications.UserNotification do
  @moduledoc """
  User Notification join-through table
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  alias Travenger.Notifications.NotificationObject

  schema "users_notifications" do
    belongs_to(:user, User)
    belongs_to(:notification_object, NotificationObject)
    timestamps()
  end

  @doc false
  def changeset(user_notification, attrs) do
    user_notification
    |> cast(attrs, [])
    |> validate_required([])
  end
end
