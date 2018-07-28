defmodule TravengerWeb.GroupControllerTest do
  @moduledoc """
  Tests for Group Controller functions
  """
  use TravengerWeb.ConnCase

  import Travenger.Factory
  import Travenger.TestHelpers

  alias TravengerWeb.GroupView
  alias TravengerWeb.MembershipView

  @unauthorized_error_code [%{"status" => "401", "title" => "Unauthorized"}]
  @forbidden_error_code [%{"status" => "403", "title" => "Forbidden"}]
  @page_fields %{"page_size" => 20, "page_number" => 1}

  setup do
    user = insert(:user)
    conn = build_user_conn(user, &build_conn/0, &put_req_header/3)

    %{conn: conn, user: user}
  end

  describe "index/2" do
    setup %{conn: conn} do
      insert(:group)
      conn = get(conn, group_path(conn, :index), @page_fields)
      %{"data" => data} = json_response(conn, :ok)

      %{data: data}
    end

    test "returns a list of groups", %{data: data} do
      assert data["page_number"] == @page_fields["page_number"]
      assert data["page_size"] == @page_fields["page_size"]
      assert data["total_entries"] == 1
      assert data["total_pages"] == 1
      refute data["entries"] == []
    end
  end

  describe "create/2" do
    setup %{conn: conn} do
      params = params_for(:group)
      conn = post(conn, group_path(conn, :create), params)
      %{assigns: %{group: group}} = conn

      %{group: group, conn: conn}
    end

    test "creates and returns group", %{group: group, conn: conn} do
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
    setup %{conn: conn} do
      group = insert(:group)
      conn = post(conn, group_group_path(conn, :join, group.id))
      %{assigns: %{membership: membership}} = conn

      %{membership: membership, conn: conn}
    end

    test "creates and returns a membership", %{
      membership: membership,
      conn: conn
    } do
      expected = render_json(MembershipView, "show.json", %{membership: membership})
      assert json_response(conn, :ok) == expected
    end

    test "returns error if user is not authenticated" do
      group = insert(:group)
      conn = build_conn()
      conn = post(conn, group_group_path(conn, :join, group.id))
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "update/2" do
    setup %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, group: group, role: :admin)

      params = %{
        name: "New Group Name",
        image_url: "http://website.com/new_image.png",
        description: "new description"
      }

      conn = put(conn, group_path(conn, :update, group.id), params)
      %{assigns: %{group: updated_group}} = conn

      %{conn: conn, group: group, updated_group: updated_group, params: params}
    end

    test "updates a group propertie/s", %{
      conn: conn,
      group: g,
      updated_group: ug
    } do
      expected = render_json(GroupView, "show.json", %{group: ug})
      assert g.id == ug.id
      assert json_response(conn, 200) == expected
    end

    test "returns error if user is not authenticated", %{params: params, group: group} do
      conn = build_conn()
      conn = put(conn, group_path(conn, :update, group.id), params)
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "update/2 when user is not the creator/admin of the group" do
    setup %{conn: conn, user: user} do
      params = %{
        name: "New Group Name",
        image_url: "http://website.com/new_image.png",
        description: "new description"
      }

      group = insert(:group)
      insert(:membership, group: group, user: user, role: :member)
      conn = put(conn, group_path(conn, :update, group.id), params)

      %{conn: conn}
    end

    test "returns error", %{conn: conn} do
      assert json_response(conn, 403)["errors"] == @forbidden_error_code
    end
  end
end
