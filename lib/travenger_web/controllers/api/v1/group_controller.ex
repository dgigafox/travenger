defmodule TravengerWeb.Api.V1.GroupController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Accounts
  alias Travenger.Accounts.User
  alias Travenger.Groups
  alias Travenger.Groups.Group

  alias TravengerWeb.Api.V1.{
    FollowingView,
    GroupView,
    MembershipView,
    RatingView
  }

  @require_auth_functions ~w(create join update invite delete follow rate)a
  @require_admin_functions ~w(invite update)a
  @require_creator_functions ~w(delete)a

  plug(Travenger.Plugs.RequireAuth when action in @require_auth_functions)

  plug(
    Travenger.Plugs.CheckGroupAdmin,
    [:creator] when action in @require_creator_functions
  )

  plug(Travenger.Plugs.CheckGroupAdmin when action in @require_admin_functions)

  action_fallback(TravengerWeb.FallbackController)

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

  def invite(conn, %{"group_id" => gid, "user_id" => uid}) do
    with %User{} = user <- Accounts.get_user(uid),
         %Group{} = group <- Groups.get_group(gid),
         {:ok, membership} <- Groups.invite(user, group) do
      conn
      |> put_status(:ok)
      |> put_view(MembershipView)
      |> render("show.json", membership: membership)
    end
  end

  def delete(conn, %{"id" => gid}) do
    with %Group{} = group <- Groups.get_group(gid),
         {:ok, group} <- Groups.delete_group(group) do
      conn
      |> put_status(:no_content)
      |> put_view(GroupView)
      |> render("show.json", group: group)
    end
  end

  def follow(%{assigns: %{user: user}} = conn, params) do
    with params <- string_keys_to_atom(params),
         %User{} = follower <- Accounts.get_user(user.id),
         {:ok, group} <- get_group(params.group_id),
         {:ok, following} <- Groups.follow_group(follower, group) do
      conn
      |> put_status(:ok)
      |> put_view(FollowingView)
      |> render("show.json", following: following)
    end
  end

  def rate(%{assigns: %{user: user}} = conn, params) do
    with params <- string_keys_to_atom(params),
         %User{} = author <- Accounts.get_user(user.id),
         {:ok, group} <- get_group(params.group_id),
         {:ok, rating} <- Groups.add_rating(author, group, params) do
      conn
      |> put_status(:ok)
      |> put_view(RatingView)
      |> render("show.json", rating: rating)
    end
  end

  defp get_group(id) do
    case Groups.get_group(id) do
      nil -> {:error, "invalid group id"}
      group -> {:ok, group}
    end
  end
end
