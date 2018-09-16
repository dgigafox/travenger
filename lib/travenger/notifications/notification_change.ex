defmodule Travenger.Notifications.NotificationChange do
  @moduledoc """
  Notification change schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  alias Travenger.Notifications.NotificationObject

  schema "notification_changes" do
    belongs_to(:notification_object, NotificationObject)
    belongs_to(:actor, User)
    timestamps()
  end

  @doc false
  def changeset(notification_change, attrs \\ %{}) do
    notification_change
    |> cast(attrs, [])
    |> validate_required([])
  end
end
