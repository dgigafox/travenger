defmodule TravengerWeb.AuthController do
  @moduledoc """
  Authentication Controller
  """

  use TravengerWeb, :controller

  import Travenger.Helpers.{
    Utils,
    Token
  }

  alias Travenger.Accounts
  alias TravengerWeb.Api.V1.UserView

  plug(Ueberauth)

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    params =
      params
      |> string_keys_to_atom()
      |> Map.put(:token, auth.credentials.token)
      |> Map.put(:email, auth.info.email)
      |> Map.put(:image_url, auth.info.image)
      |> Map.put(:name, auth.info.name)
      |> Map.put(:first_name, auth.info.first_name)
      |> Map.put(:last_name, auth.info.last_name)

    authenticate_or_register(conn, params)
  end

  def authenticate_or_register(conn, params) do
    with {:ok, user} <- Accounts.auth_or_register_user(params),
         {:ok, token} <- generate_auth_token(user) do
      conn
      |> put_view(UserView)
      |> render("token.json", token: token)
    end
  end
end
