defmodule TravengerWeb.Api.V1.UserControllerTest do
  use TravengerWeb.ConnCase

  import Travenger.Factory
  import Travenger.TestHelpers

  alias TravengerWeb.Api.V1.FollowingView
  alias TravengerWeb.Api.V1.UserView
  alias TravengerWeb.ErrorView

  setup do
    user = insert(:user)
    conn = build_user_conn(user, &build_conn/0, &put_req_header/3)
    %{conn: conn, user: user}
  end

  describe "index/2" do
    test "returns a paginated list of users", %{conn: conn} do
      conn = get(conn, api_v1_user_path(conn, :index))
      %{"data" => data} = json_response(conn, :ok)

      assert data["page_number"]
      assert data["page_size"]
      assert data["total_entries"]
      assert data["total_pages"]
      refute data["entries"] == []
    end

    test "returns a paginated list of users given gender", %{conn: conn} do
      params = %{gender: :male}
      conn = get(conn, api_v1_user_path(conn, :index), params)
      %{"data" => data} = json_response(conn, :ok)

      assert data["total_entries"] == 1
    end

    test "returns a paginated list of users given keyword", %{conn: conn} do
      insert(:user, name: "Shirly Gegantino")
      params = %{search: "geg"}
      conn = get(conn, api_v1_user_path(conn, :index), params)
      %{"data" => data} = json_response(conn, :ok)

      assert data["total_entries"] == 2
    end
  end

  describe "show/2" do
    test "returns a user given id", %{conn: conn, user: user} do
      conn = get(conn, api_v1_user_path(conn, :show, user.id))
      expected = render_json(UserView, "show.json", %{user: user})

      assert json_response(conn, :ok) == expected
    end

    test "returns a user given email", %{conn: conn, user: user} do
      params = %{email: user.email}
      conn = get(conn, api_v1_user_path(conn, :show, user.id), params)
      expected = render_json(UserView, "show.json", %{user: user})

      assert json_response(conn, :ok) == expected
    end

    test "returns a user given id and name", %{conn: conn, user: user} do
      params = %{name: user.name}
      conn = get(conn, api_v1_user_path(conn, :show, user.id), params)
      expected = render_json(UserView, "show.json", %{user: user})

      assert json_response(conn, :ok) == expected
    end

    test "returns 404 if user does not exist", %{conn: conn} do
      conn = get(conn, api_v1_user_path(conn, :show, 10_000))

      assert json_response(conn, :not_found) == render_json(ErrorView, "404.json", [])
    end
  end

  describe "follow/2" do
    test "returns a following record with follower and followee", %{
      conn: conn
    } do
      followee = insert(:user)
      conn = post(conn, api_v1_user_user_path(conn, :follow, followee.id))
      %{assigns: %{following: following}} = conn
      expected = render_json(FollowingView, "show.json", %{following: following})

      assert json_response(conn, :ok) == expected
    end
  end
end
