defmodule TravengerWeb.AuthController do
  use TravengerWeb, :controller
  import Travenger.Helpers.Utils

  alias Travenger.Accounts

  plug(Ueberauth)

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    with params <- string_keys_to_atom(params),
         user_info <- string_keys_to_atom(auth.extra.raw_info.user) do
      params =
        params
        |> Map.put(:token, auth.credentials.token)
        |> Map.put(:email, auth.info.email)
        |> Map.put(:image_url, auth.info.image)
        |> Map.put(:name, auth.info.name)
        |> Map.put(:first_name, auth.info.first_name)
        |> Map.put(:last_name, auth.info.last_name)
        |> Map.put(:gender, user_info.gender)

      authenticate_or_register(conn, params)
    end
  end

  def authenticate_or_register(conn, params) do
    with {:ok, user} <- Accounts.auth_or_register_user(params) do
      conn
      |> put_view(TravengerWeb.UserView)
      |> render("token.json", user: user)
    end
  end
end
