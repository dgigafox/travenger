defmodule Travenger.Notifications.Notification do
  @moduledoc """
  Notification schema
  """
  use Ecto.Schema

  alias Travenger.Accounts.User
  alias Travenger.Notifications.NotificationObject

  @derive {Poison.Encoder, only: [:notification_object, :inserted_at]}

  schema "notifications" do
    belongs_to(:notification_object, NotificationObject)
    belongs_to(:notifier, User)
    timestamps()
  end
end
