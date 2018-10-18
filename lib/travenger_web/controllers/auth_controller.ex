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
        |> add_gender(user_info)

      authenticate_or_register(conn, params)
    end
  end

  def authenticate_or_register(conn, params) do
    with {:ok, user} <- Accounts.auth_or_register_user(params),
         {:ok, token} <- generate_auth_token(user) do
      conn
      |> put_view(UserView)
      |> render("token.json", token: token)
    end
  end

  defp add_gender(params, info) do
    case info do
      %{gender: gender} -> Map.put(params, :gender, gender)
      _ -> params
    end
  end
end
