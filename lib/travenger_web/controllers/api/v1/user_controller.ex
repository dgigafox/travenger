defmodule TravengerWeb.Api.V1.UserController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Accounts
  alias Travenger.Accounts.User

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
end