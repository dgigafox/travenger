defmodule Travenger.GroupsTest do
  use Travenger.DataCase

  import Travenger.Factory

  alias Travenger.Groups

  describe "create_group/1" do
    test "return a created group" do
      {:ok, group} = Groups.create_group(params_for(:group))

      assert group.id
      assert group.name
      assert group.image_url
      assert group.description
    end
  end
end
