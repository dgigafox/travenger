defmodule TravengerWeb.NotificationChannel do
  @moduledoc """
  Notification Channel
  """
  use TravengerWeb, :channel

  def join("notifications:" <> id, _params, socket) do
    verify_user(id, socket)
  end

  defp verify_user(id, socket) do
    case String.to_integer(id) === socket.assigns.user.id do
      true -> {:ok, socket}
      _ -> {:error, "User unauthorized"}
    end
  end
end
