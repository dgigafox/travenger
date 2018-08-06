defmodule TravengerWeb.Api.V1.MembershipController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Accounts.Membership
  alias Travenger.Groups
  alias TravengerWeb.Api.V1.MembershipView

  plug(Travenger.Plugs.RequireAuth when action in [:approve])
  plug(Travenger.Plugs.CheckGroupAdmin when action in [:approve])

  def approve(conn, params) do
    with %{membership_id: m_id} <- string_keys_to_atom(params),
         %Membership{} = membership <- Groups.get_membership(m_id),
         {:ok, membership} <- Groups.approve_join_request(membership) do
      conn
      |> put_status(:ok)
      |> put_view(MembershipView)
      |> render("show.json", membership: membership)
    end
  end
end
