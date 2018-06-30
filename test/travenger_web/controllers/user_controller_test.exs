defmodule TravengerWeb.UserControllerTest do
  use TravengerWeb.ConnCase

  import Travenger.Factory

  alias TravengerWeb.{
    ErrorView,
    UserView
  }

  setup do
    %{
      conn: build_conn(),
      user: insert(:user)
    }
  end

  describe "show/2" do
    test "returns a user given id", %{conn: conn, user: user}do
      conn = get(conn, user_path(conn, :show, user.id))

      assert json_response(conn, :ok) ==
             render_json(UserView, "show.json", %{user: user})
    end

    test "returns a user given email", %{conn: conn, user: user} do
      params = %{email: user.email}
      conn = get(conn, user_path(conn, :show, user.id), params)

      assert json_response(conn, :ok) ==
             render_json(UserView, "show.json", %{user: user})
    end

    test "returns a user given id and name", %{conn: conn, user: user} do
      params = %{name: user.name}
      conn = get(conn, user_path(conn, :show, user.id), params)

      assert json_response(conn, :ok) ==
             render_json(UserView, "show.json", %{user: user})
    end

    test "returns 404 if user does not exist", %{conn: conn} do
      conn = get(conn, user_path(conn, :show, 10_000))

      assert json_response(conn, :not_found) ==
             render_json(ErrorView, "404.json", [])
    end
  end
end
