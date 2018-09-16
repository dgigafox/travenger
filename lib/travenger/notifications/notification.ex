defmodule Travenger.Notifications.Notification do
  @moduledoc """
  Notification schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  alias Travenger.Notifications.NotificationObject

  schema "notifications" do
    belongs_to(:notification_object, NotificationObject)
    belongs_to(:notifier, User)
    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [])
    |> validate_required([])
  end
end
