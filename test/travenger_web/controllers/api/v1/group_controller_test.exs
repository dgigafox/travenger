defmodule TravengerWeb.Api.V1.GroupControllerTest do
  @moduledoc """
  Tests for Group Controller functions
  """
  use TravengerWeb.ConnCase

  import Travenger.Factory
  import Travenger.TestHelpers

  alias Travenger.Groups.Group
  alias Travenger.Repo

  alias TravengerWeb.Api.V1.{
    FollowingView,
    GroupView,
    InvitationView,
    MembershipView,
    RatingView
  }

  @unauthorized_error_code [%{"status" => "401", "title" => "Unauthorized"}]
  @forbidden_error_code [%{"status" => "403", "title" => "Forbidden"}]
  @page_fields %{"page_size" => 20, "page_number" => 1}
  @invalid_group_error "invalid group id"

  setup do
    user = insert(:user)
    conn = build_user_conn(user, &build_conn/0, &put_req_header/3)

    %{conn: conn, user: user}
  end

  describe "index/2" do
    setup %{conn: conn} do
      insert(:group)
      conn = get(conn, api_v1_group_path(conn, :index), @page_fields)
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

  describe "index/2 with keyword" do
    setup %{conn: conn} do
      group = insert(:group, name: "Sample Travel Group")
      insert_list(2, :group)
      params = %{search: "sample"}
      conn = get(conn, api_v1_group_path(conn, :index), params)
      %{"data" => data} = json_response(conn, :ok)

      %{data: data, group: group}
    end

    test "returns a list of groups", %{data: data, group: group} do
      assert data["total_entries"] == 1
      [head | _] = data["entries"]
      assert head["name"] == group.name
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      group = insert(:group)
      conn = get(conn, api_v1_group_path(conn, :show, group.id))
      %{"data" => data} = json_response(conn, :ok)

      %{data: data}
    end

    test "returns a group", %{data: data} do
      assert data["id"]
    end
  end

  describe "create/2" do
    setup %{conn: conn} do
      params = params_for(:group)
      conn = post(conn, api_v1_group_path(conn, :create), params)
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
      conn = post(conn, api_v1_group_path(conn, :create), params)
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "join/2" do
    setup %{conn: conn} do
      group = insert(:group)
      conn = post(conn, api_v1_group_group_path(conn, :join, group.id))
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
      conn = post(conn, api_v1_group_group_path(conn, :join, group.id))
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

      conn = put(conn, api_v1_group_path(conn, :update, group.id), params)
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
      conn = put(conn, api_v1_group_path(conn, :update, group.id), params)
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
      conn = put(conn, api_v1_group_path(conn, :update, group.id), params)

      %{conn: conn}
    end

    test "returns error", %{conn: conn} do
      assert json_response(conn, 403)["errors"] == @forbidden_error_code
    end
  end

  describe "invite/2" do
    setup %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, group: group, role: :admin)
      params = %{user_id: insert(:user).id}
      path = api_v1_group_group_path(conn, :invite, group.id)
      conn = post(conn, path, params)
      %{assigns: %{invitation: invitation}} = conn

      %{
        conn: conn,
        invitation: invitation,
        user: user,
        group: group,
        params: params
      }
    end

    test "returns an invitation", %{
      conn: conn,
      invitation: inv
    } do
      expected = render_json(InvitationView, "show.json", %{invitation: inv})
      assert json_response(conn, :ok) == expected
    end

    test "returns error when user is not authenticated", %{
      group: group,
      params: params
    } do
      conn = build_conn()
      path = api_v1_group_group_path(conn, :invite, group.id)
      conn = post(conn, path, params)
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "invite/2 when user is not the creator/admin of the group" do
    setup %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, group: group, role: :member)

      params = %{user_id: insert(:user).id}
      path = api_v1_group_group_path(conn, :invite, group.id)
      conn = post(conn, path, params)

      %{conn: conn}
    end

    test "returns error", %{conn: conn} do
      assert json_response(conn, 403)["errors"] == @forbidden_error_code
    end
  end

  describe "delete/2" do
    setup %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, group: group, role: :creator)
      path = api_v1_group_path(conn, :delete, group.id)
      conn = delete(conn, path)
      %{assigns: %{group: group}} = conn

      %{
        conn: conn,
        group: group
      }
    end

    test "returns a group with updated deleted_at", c do
      expected = render_json(GroupView, "show.json", %{group: c.group})
      group = Repo.get(Group, c.group.id)

      assert group.deleted_at
      assert json_response(c.conn, 204) == expected
    end

    test "returns error when user is not authenticated", c do
      conn = build_conn()
      path = api_v1_group_path(conn, :delete, c.group.id)
      conn = put(conn, path)
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "delete/2 when user is not the creator of the group" do
    setup %{conn: conn, user: user} do
      group = insert(:group)
      insert(:membership, user: user, group: group, role: :admin)
      path = api_v1_group_path(conn, :delete, group.id)
      conn = delete(conn, path)

      %{conn: conn}
    end

    test "returns error", %{conn: conn} do
      assert json_response(conn, 403)["errors"] == @forbidden_error_code
    end
  end

  describe "follow/2" do
    setup %{conn: conn} do
      group = insert(:group)
      conn = post(conn, api_v1_group_group_path(conn, :follow, group.id))
      %{assigns: %{following: following}} = conn

      %{conn: conn, group: group, following: following}
    end

    test "returns a following record with follower and followed group", c do
      expected = render_json(FollowingView, "show.json", %{following: c.following})

      assert json_response(c.conn, :ok) == expected
    end

    test "returns error when user is not authenticated", c do
      conn = build_conn()
      conn = post(conn, api_v1_group_group_path(conn, :follow, c.group.id))
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "follow/2 when group does not exist" do
    test "returns error", %{conn: conn} do
      conn = post(conn, api_v1_group_group_path(conn, :follow, 9_999))
      assert json_response(conn, 400)["error"] == @invalid_group_error
    end
  end

  describe "rate/2" do
    setup %{conn: conn} do
      group = insert(:group)
      params = %{rating: 5}
      conn = post(conn, api_v1_group_group_path(conn, :rate, group.id), params)
      %{assigns: %{rating: rating}} = conn

      %{conn: conn, group: group, rating: rating, params: params}
    end

    test "returns a rating", c do
      expected = render_json(RatingView, "show.json", %{rating: c.rating})

      assert json_response(c.conn, :ok) == expected
    end

    test "returns error when user is not authenticated", c do
      conn = build_conn()
      path = api_v1_group_group_path(conn, :rate, c.group.id)
      conn = post(conn, path, c.params)
      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end
end
