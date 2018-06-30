defmodule TravengerWeb.UserController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Accounts
  alias Travenger.Accounts.User

  def show(conn, params) do
    with params <- string_keys_to_atom(params),
         %User{} = user <- Accounts.find_user(params) do
      render(conn, "show.json", user: user)
    end
  end
end
