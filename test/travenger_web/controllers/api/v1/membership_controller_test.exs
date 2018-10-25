defmodule TravengerWeb.Api.V1.MembershipControllerTest do
  @moduledoc """
  Tests for Group Controller functions
  """
  use TravengerWeb.ConnCase

  import Travenger.Factory
  import Travenger.TestHelpers

  alias TravengerWeb.Api.V1.MembershipView

  @unauthorized_error_code [%{"status" => "401", "title" => "Unauthorized"}]
  @forbidden_error_code [%{"status" => "403", "title" => "Forbidden"}]

  setup do
    user = insert(:user)
    conn = build_user_conn(user, &build_conn/0, &put_req_header/3)
    %{conn: conn, user: user}
  end

  describe "approve/2" do
    setup %{conn: conn, user: user} do
      grp = insert(:group)
      insert(:membership, user: user, group: grp, role: :creator)
      m = insert(:membership, group: grp)

      path =
        api_v1_group_membership_membership_path(
          conn,
          :approve,
          grp.id,
          m.id
        )

      conn = put(conn, path)
      %{assigns: %{membership: membership}} = conn

      %{membership: membership, conn: conn, group: grp}
    end

    test "returns a membership with role member", %{membership: m, conn: conn} do
      expected = render_json(MembershipView, "show.json", %{membership: m})
      assert json_response(conn, :ok) == expected
    end

    test "returns error when user is not authenticated", %{
      group: g,
      membership: m
    } do
      conn = build_conn()
      path = api_v1_group_membership_membership_path(conn, :approve, g.id, m.id)
      conn = put(conn, path)
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "approve/2 when current user is not creator/admin" do
    setup %{conn: conn, user: user} do
      grp = insert(:group)
      insert(:membership, user: user, group: grp, role: :member)
      m = insert(:membership, group: grp)

      path =
        api_v1_group_membership_membership_path(
          conn,
          :approve,
          grp.id,
          m.id
        )

      conn = put(conn, path)

      %{conn: conn}
    end

    test "returns error", %{conn: conn} do
      assert json_response(conn, 403)["errors"] == @forbidden_error_code
    end
  end

  describe "assign_admin/2" do
    setup %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, group: group, role: :admin)
      membership = insert(:membership, group: group, role: :member)

      path =
        api_v1_group_membership_membership_path(
          conn,
          :assign_admin,
          group.id,
          membership.id
        )

      conn = put(conn, path)
      %{assigns: %{membership: membership}} = conn

      %{membership: membership, conn: conn, group: group}
    end

    test "returns a membership with admin member", c do
      expected = render_json(MembershipView, "show.json", %{membership: c.membership})
      assert json_response(c.conn, :ok) == expected
    end

    test "returns error when user is not authenticated", c do
      conn = build_conn()

      path =
        api_v1_group_membership_membership_path(
          conn,
          :assign_admin,
          c.group.id,
          c.membership.id
        )

      conn = put(conn, path)

      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "assign_admin/2 when current user is not creator/admin of the group" do
    test "returns error", %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, role: :admin)
      membership = insert(:membership, group: group, role: :member)

      path =
        api_v1_group_membership_membership_path(
          conn,
          :assign_admin,
          group.id,
          membership.id
        )

      conn = put(conn, path)

      assert json_response(conn, 403)["errors"] == @forbidden_error_code
    end
  end

  describe "remove_admin/2" do
    setup %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, group: group, role: :admin)
      membership = insert(:membership, group: group, role: :admin)

      path =
        api_v1_group_membership_membership_path(
          conn,
          :remove_admin,
          group.id,
          membership.id
        )

      conn = put(conn, path)
      %{assigns: %{membership: membership}} = conn

      %{membership: membership, conn: conn, group: group}
    end

    test "returns an updated membership", c do
      expected = render_json(MembershipView, "show.json", %{membership: c.membership})
      assert json_response(c.conn, :ok) == expected
    end

    test "returns error when user is not authenticated", c do
      conn = build_conn()

      path =
        api_v1_group_membership_membership_path(
          conn,
          :remove_admin,
          c.group.id,
          c.membership.id
        )

      conn = put(conn, path)

      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "remove_admin/2 when current user is not creator/admin of the group" do
    test "returns error", %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, role: :admin)
      membership = insert(:membership, group: group, role: :member)

      path =
        api_v1_group_membership_membership_path(
          conn,
          :remove_admin,
          group.id,
          membership.id
        )

      conn = put(conn, path)

      assert json_response(conn, 403)["errors"] == @forbidden_error_code
    end
  end
end
