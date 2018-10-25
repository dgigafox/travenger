defmodule TravengerWeb.Api.V1.MembershipController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Accounts.Membership
  alias Travenger.Groups
  alias TravengerWeb.Api.V1.MembershipView

  @require_auth_functions ~w(approve assign_admin remove_admin)a
  @require_admin_functions ~w(approve assign_admin remove_admin)a

  plug(Travenger.Plugs.RequireAuth when action in @require_auth_functions)
  plug(Travenger.Plugs.CheckGroupAdmin when action in @require_admin_functions)

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

  def assign_admin(conn, %{"membership_id" => id}) do
    with %Membership{} = membership <- Groups.get_membership(id),
         {:ok, membership} <- Groups.assign_admin(membership) do
      conn
      |> put_status(:ok)
      |> put_view(MembershipView)
      |> render("show.json", membership: membership)
    end
  end

  def remove_admin(conn, %{"membership_id" => id}) do
    with %Membership{} = membership <- Groups.get_membership(id),
         {:ok, membership} <- Groups.remove_admin(membership) do
      conn
      |> put_status(:ok)
      |> put_view(MembershipView)
      |> render("show.json", membership: membership)
    end
  end
end
