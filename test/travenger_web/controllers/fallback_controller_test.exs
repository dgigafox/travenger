defmodule FallbackControllerTest do
  use TravengerWeb.ConnCase

  import TravengerWeb.FallbackController

  alias Ecto.Changeset
  alias TravengerWeb.{
    ChangesetView,
    ErrorView
  }

  describe "call/2" do
    setup do
      %{conn: build_conn()}
    end

    test "return not found error", %{conn: conn} do
      conn = call(conn, nil)
      assert json_response(conn, :not_found) ==
             render_json(ErrorView, "404.json", [])
    end

    test "return changeset errors", %{conn: conn} do
      ch = %Changeset{
        action: :insert,
        changes: %{
          email: "testuser@gmail.com",
          password: "pass",
          password_confirmation: "pass"
        },
        errors: [email: {"is required", [validation: :required]}],
        data: %{},
        valid?: false
      }
      conn = call(conn, {:error, ch})

      assert json_response(conn, :unprocessable_entity) ==
             render_json(ChangesetView, "error.json", %{changeset: ch})
    end
  end
end
