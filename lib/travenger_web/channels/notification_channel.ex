defmodule TravengerWeb.NotificationChannel do
  @moduledoc """
  Notification Channel
  """
  use TravengerWeb, :channel

  alias Travenger.Notifications

  def join("notifications:" <> id, params, socket) do
    params = Map.put(params, :notifier_id, id)

    with {:ok, socket} <- verify_user(id, socket),
         %{entries: notifs} <- Notifications.list_notifications(params) do
      {:ok, %{notifications: notifs}, socket}
    end
  end

  defp verify_user(id, socket) do
    case String.to_integer(id) === socket.assigns.user.id do
      true -> {:ok, socket}
      _ -> {:error, "User unauthorized"}
    end
  end
end
