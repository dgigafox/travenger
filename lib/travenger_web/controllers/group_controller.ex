defmodule TravengerWeb.GroupController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Groups
  alias Travenger.Groups.Group

  plug(Travenger.Plugs.RequireAuth when action in [:create, :join])

  def create(%{assigns: %{user: user}} = conn, params) do
    with params <- string_keys_to_atom(params),
         {:ok, group} <- Groups.create_group(user, params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{group: group})
    end
  end

  def join(%{assigns: %{user: user}} = conn, params) do
    with %{id: group_id} <- string_keys_to_atom(params),
         %Group{} = group <- Groups.get_group(group_id),
         {:ok, user_group} <- Groups.join_group(user, group) do
      conn
      |> put_status(:ok)
      |> put_view(TravengerWeb.UserGroupView)
      |> render("show.json", user_group: user_group)
    end
  end
end
