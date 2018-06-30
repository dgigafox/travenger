defmodule TravengerWeb.ChangesetViewTest do
  use ExUnit.Case, async: true

  alias TravengerWeb.ChangesetView
  alias Ecto.Changeset

  @error "is required"
  @changeset %Changeset{
    action: :insert,
    changes: %{
      email: "testuser@gmail.com",
      password: "pass",
      password_confirmation: "pass"
    },
    errors: [email: {@error, [validation: :required]}],
    data: %{},
    valid?: false
  }

  @nested_changeset %Changeset{
    action: :insert,
    changes: %{
      user: %Changeset{
        action: :insert,
        changes: %{
          email: "test@gmail.com",
          member_key: "email-memberkey"
        },
        errors: [email: {@error, []}],
        data: %{},
        valid?: false
      },
      exchange: %Changeset{
        action: :update,
        changes: %{
          name: "Sample Exchange"
        },
        errors: [name: @error],
        data: %{},
        valid?: false
      }
    },
    errors: [],
    data: %{},
    valid?: false
  }

  describe "error.json" do
    test "returns errors on invalid changeset" do
      params = %{changeset: @changeset}
      %{errors: errors} = ChangesetView.render("error.json", params)

      assert errors == [
        %{email: @error}
      ]
    end

    test "returns errors on invalid nested changesets" do
      params = %{changeset: @nested_changeset}
      %{errors: errors} = ChangesetView.render("error.json", params)

      assert errors == [
        %{name: @error},
        %{email: @error}
      ]
    end
  end
end
