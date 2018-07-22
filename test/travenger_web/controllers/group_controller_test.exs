defmodule TravengerWeb.GroupControllerTest do
  @moduledoc """
  Tests for Group Controller functions
  """
  use TravengerWeb.ConnCase

  import Travenger.Factory
  import Travenger.TestHelpers

  alias TravengerWeb.GroupView
  alias TravengerWeb.UserGroupView

  @unauthorized_error_code [%{"status" => "401", "title" => "Unauthorized"}]

  setup do
    user = insert(:user)
    conn = build_user_conn(user, &build_conn/0, &put_req_header/3)

    %{conn: conn}
  end

  describe "create/2" do
    test "creates and returns group", %{conn: conn} do
      params = params_for(:group)
      conn = post(conn, group_path(conn, :create), params)
      %{assigns: %{group: group}} = conn
      expected = render_json(GroupView, "show.json", %{group: group})

      assert json_response(conn, :created) == expected
    end

    test "returns error if user is not authenticated" do
      params = params_for(:group)
      conn = build_conn()
      conn = post(conn, group_path(conn, :create), params)
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "join/2" do
    test "creates and returns a user_group", %{conn: conn} do
      group = insert(:group)
      conn = post(conn, group_path(conn, :join, group.id))
      %{assigns: %{user_group: user_group}} = conn
      expected = render_json(UserGroupView, "show.json", %{user_group: user_group})

      assert json_response(conn, :ok) == expected
    end

    test "returns error if user is not authenticated" do
      group = insert(:group)
      conn = build_conn()
      conn = post(conn, group_path(conn, :join, group.id))
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end
end
