defmodule TravengerWeb.Api.V1.InvitationControllerTest do
  @moduledoc """
  Tests for Group Controller functions
  """
  use TravengerWeb.ConnCase

  import Travenger.Factory
  import Travenger.TestHelpers

  alias TravengerWeb.Api.V1.InvitationView

  @page_fields %{"page_size" => 20, "page_number" => 1}
  @not_found_error_code [%{"status" => "404", "title" => "Resource not found"}]
  @unauthorized_error_code [%{"status" => "401", "title" => "Unauthorized"}]

  setup do
    user = insert(:user)
    conn = build_user_conn(user, &build_conn/0, &put_req_header/3)
    %{conn: conn, user: user}
  end

  describe "index/2" do
    setup %{conn: conn, user: user} do
      insert(:invitation, user: user, type: :group)
      insert(:invitation, user: insert(:user), type: :group)
      insert(:invitation, user: user, type: :event)
      path = api_v1_invitation_path(conn, :index)
      conn = get(conn, path, Map.put(@page_fields, "type", "group"))

      %{conn: conn}
    end

    test "returns a list of group invitations of the current user", %{conn: conn} do
      %{"data" => data} = json_response(conn, :ok)

      assert data["page_number"] == @page_fields["page_number"]
      assert data["page_size"] == @page_fields["page_size"]
      assert data["total_entries"] == 1
      assert data["total_pages"] == 1
      refute data["entries"] == []
    end

    test "returns error if user is not authenticated" do
      conn = build_conn()
      path = api_v1_invitation_path(conn, :index)
      conn = get(conn, path, Map.put(@page_fields, "type", "group"))

      assert json_response(conn, 401)["errors"] == @unauthorized_error_code
    end
  end

  describe "accept/2 for group invitation" do
    setup %{user: user} do
      group = insert(:group)

      invitation =
        insert(:invitation, %{
          user: user,
          group: group
        })

      insert(:membership, %{
        user: user,
        group: group,
        membership_status: %{status: :invited}
      })

      %{invitation: invitation}
    end

    test "returns an accepted invitation", %{conn: conn, invitation: invitation} do
      path = api_v1_invitation_invitation_path(conn, :accept, invitation.id)
      conn = put(conn, path)
      %{assigns: %{invitation: invitation}} = conn

      assert json_response(conn, :ok) ==
               render_json(InvitationView, "show.json", %{invitation: invitation})

      assert json_response(conn, :ok)["data"]["status"] == "accepted"
    end

    test "returns 404 if user does not own the invitation", %{invitation: invitation} do
      user = insert(:user)
      conn = build_user_conn(user, &build_conn/0, &put_req_header/3)
      path = api_v1_invitation_invitation_path(conn, :accept, invitation.id)
      conn = put(conn, path)

      assert json_response(conn, :not_found)["errors"] == @not_found_error_code
    end

    test "returns error if user is not authenticated", %{invitation: invitation} do
      conn = build_conn()
      path = api_v1_invitation_invitation_path(conn, :accept, invitation.id)
      conn = put(conn, path)

      assert json_response(conn, :unauthorized)["errors"] == @unauthorized_error_code
    end
  end
end
