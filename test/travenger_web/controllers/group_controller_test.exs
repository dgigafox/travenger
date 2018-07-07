defmodule TravengerWeb.GroupControllerTest do
  use TravengerWeb.ConnCase

  import Travenger.Factory

  alias TravengerWeb.GroupView

  setup do
    %{
      conn: build_conn(),
      user: insert(:user)
    }
  end

  describe "create/2" do
    test "creates and returns group", %{conn: conn} do
      params = params_for(:group)
      conn = post(conn, group_path(conn, :create), params)
      %{assigns: %{group: group}} = conn

      assert json_response(conn, :created) ==
        render_json(GroupView, "show.json", %{group: group})
    end
  end
end
