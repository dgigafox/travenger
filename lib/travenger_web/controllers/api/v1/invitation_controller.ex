defmodule TravengerWeb.Api.V1.InvitationController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Accounts

  plug(Travenger.Plugs.RequireAuth when action in [:index])

  action_fallback(TravengerWeb.FallbackController)

  def index(%{assigns: %{user: user}} = conn, params) do
    with {:ok, _} <- check_ownership(conn, params) do
      render(conn, "index.json", invitations: Accounts.list_invitations(params))
    end
  end

  defp check_ownership(%{assigns: %{user: user}} = conn, %{"user_id" => uid} = params) do
    case user.id == String.to_integer(uid) do
      true -> {:ok, true}
      _ -> nil
    end
  end
end
