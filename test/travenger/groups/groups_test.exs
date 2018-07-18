defmodule Travenger.GroupsTest do
  use Travenger.DataCase

  import Travenger.Factory

  alias Travenger.Groups

  describe "create_group/1" do
    setup do
      user = insert(:user)
      {:ok, group} = Groups.create_group(user, params_for(:group))

      %{group: group, user: user}
    end

    test "returns a created group", %{group: group} do
      assert group.id
      assert group.name
      assert group.image_url
      assert group.description
    end

    test "creates a member with role creator", %{group: group, user: user} do
      [head | _] = group.members
      assert head.role == :creator
      assert head.user_id == user.id
    end
  end
end
