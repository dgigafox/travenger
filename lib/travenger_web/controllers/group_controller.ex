defmodule TravengerWeb.GroupController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Groups
  alias Travenger.Groups.Group
  alias TravengerWeb.MembershipView

  plug(Travenger.Plugs.RequireAuth when action in [:create, :join, :update])
  plug(Travenger.Plugs.CheckGroupAdmin when action in [:update])

  def index(conn, params \\ %{}) do
    params = string_keys_to_atom(params)
    render(conn, "index.json", groups: Groups.list_groups(params))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", group: Groups.get_group(id))
  end

  def create(%{assigns: %{user: user}} = conn, params) do
    with params <- string_keys_to_atom(params),
         {:ok, group} <- Groups.create_group(user, params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{group: group})
    end
  end

  def join(%{assigns: %{user: user}} = conn, %{"group_id" => gid}) do
    with %Group{} = group <- Groups.get_group(gid),
         {:ok, membership} <- Groups.join_group(user, group) do
      conn
      |> put_status(:ok)
      |> put_view(MembershipView)
      |> render("show.json", membership: membership)
    end
  end

  def update(conn, %{"id" => gid} = params) do
    with params <- string_keys_to_atom(params),
         %Group{} = group <- Groups.get_group(gid),
         {:ok, group} <- Groups.update_group(group, params) do
      render(conn, "show.json", group: group)
    end
  end
end
