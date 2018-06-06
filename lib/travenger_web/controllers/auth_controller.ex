defmodule TravengerWeb.AuthController do
  use TravengerWeb, :controller
  import Travenger.Helpers.Utils

  alias Travenger.Accounts

  plug(Ueberauth)

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    with params <- string_keys_to_atom(params) do
      params =
        params
        |> Map.put(:token, auth.credentials.token)
        |> Map.put(:email, auth.info.email)
        |> Map.put(:image_url, auth.info.image)

      authenticate_or_register(conn, params)
    end
  end

  def authenticate_or_register(conn, params) do
    with {:ok, user} <- Accounts.auth_or_register_users(params) do
      conn
      |> put_view(TravengerWeb.UserView)
      |> render("show.json", user: user)
    end
  end
end
