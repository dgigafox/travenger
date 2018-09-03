defmodule TravengerWeb.Api.V1.UserController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Accounts
  alias Travenger.Accounts.User
  alias TravengerWeb.Api.V1.FollowingView

  plug(Travenger.Plugs.RequireAuth when action in [:follow])

  action_fallback(TravengerWeb.FallbackController)

  def index(conn, params) do
    users = Accounts.list_users(params)
    render(conn, "index.json", users: users)
  end

  def show(conn, params) do
    with params <- string_keys_to_atom(params),
         %User{} = user <- Accounts.find_user(params) do
      render(conn, "show.json", user: user)
    end
  end

  def follow(%{assigns: %{user: user}} = conn, params) do
    with params <- string_keys_to_atom(params),
         {:ok, follower} <- get_user(user.id),
         {:ok, followee} <- get_user(params.user_id),
         {:ok, following} <- Accounts.follow_user(follower, followee) do
      conn
      |> put_status(:ok)
      |> put_view(FollowingView)
      |> render("show.json", following: following)
    end
  end

  defp get_user(id) do
    case Accounts.get_user(id) do
      nil -> {:error, "invalid user id"}
      user -> {:ok, user}
    end
  end
end
