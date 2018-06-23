defmodule TravengerWeb.AuthControllerTest do
  use TravengerWeb.ConnCase

  test "Sign in with Facebook", %{conn: conn} do
    conn = get(conn, "/auth/facebook?scope=email,public_profile")
    assert redirected_to(conn, 302)
  end
end
