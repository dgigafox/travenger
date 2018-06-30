defmodule TravengerWeb.UserControllerTest do
  use TravengerWeb.ConnCase

  import Travenger.Factory

  alias TravengerWeb.UserView

  setup do
    %{
      conn: build_conn(),
      user: insert(:user)
    }
  end

  describe "show/2" do
    test "returns a user", %{conn: conn, user: user}do
      conn = get(conn, user_path(conn, :show, user.id))

      assert json_response(conn, :ok) ==
             render_json(UserView, "show.json", %{user: user})
    end
  end
end
