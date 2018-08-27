defmodule TravengerWeb.Api.V1.InvitationController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils
  alias Travenger.Accounts

  plug(Travenger.Plugs.RequireAuth when action in [:index, :accept])

  action_fallback(TravengerWeb.FallbackController)

  def index(conn, params) do
    with {:ok} <- check_ownership(conn, params) do
      render(conn, "index.json", invitations: Accounts.list_invitations(params))
    end
  end

  def accept(%{assigns: %{user: user}} = conn, params) do
    params =
      params
      |> string_keys_to_atom()
      |> Map.put(:user_id, user.id)

    with {:ok, invitation} <- find_invitation(params),
         {:ok, invitation} <- Accounts.accept_invitation(invitation) do
      render(conn, "show.json", invitation: invitation)
    end
  end

  defp find_invitation(%{invitation_id: id} = params) do
    params = Map.put(params, :id, id)

    case Accounts.find_invitation(params) do
      nil -> nil
      invitation -> {:ok, invitation}
    end
  end

  defp check_ownership(%{assigns: %{user: user}}, %{"user_id" => uid}) do
    case user.id == String.to_integer(uid) do
      true -> {:ok}
      _ -> nil
    end
  end
end
