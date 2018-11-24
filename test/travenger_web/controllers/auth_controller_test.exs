defmodule TravengerWeb.AuthControllerTest do
  use TravengerWeb.ConnCase

  @sample_callback_payload %Ueberauth.Auth{
    credentials: %Ueberauth.Auth.Credentials{
      token: "token"
    },
    info: %Ueberauth.Auth.Info{
      description: nil,
      email: "darren_gegantino_facebook@yahoo.com",
      first_name: "Darren",
      image: "http://graph.facebook.com/10216277902323229/picture?type=square",
      last_name: "Gegantino",
      location: nil,
      name: "Darren Gegantino",
      nickname: nil,
      phone: nil,
      urls: %{facebook: nil, website: nil}
    }
  }

  describe "GET auth/facebook" do
    test "Sign in with Facebook", %{conn: conn} do
      conn = get(conn, "/auth/facebook?scope=email,public_profile")
      assert redirected_to(conn, 302)
    end
  end

  describe "GET auth/facebook/callback" do
    @tag :todo
    test "authenticates a user", %{conn: conn} do
      conn = assign(conn, :ueberauth_auth, @sample_callback_payload)
      conn = get(conn, auth_path(conn, :callback, "facebook"))

      assert %{"data" => %{"token" => _token}} = json_response(conn, 200)
    end
  end
end
