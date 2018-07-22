defmodule TravengerWeb.UserGroupView do
  use TravengerWeb, :view

  alias __MODULE__

  alias TravengerWeb.{
    GroupView,
    MembershipStatusView,
    UserView
  }

  def render("show.json", %{user_group: user_group}) do
    %{data: render_one(user_group, UserGroupView, "user_group.json")}
  end

  def render("user_group.json", %{user_group: user_group}) do
    %{
      id: user_group.id,
      group: render_one(user_group.group, GroupView, "group.json"),
      role: user_group.role,
      user: render_one(user_group.user, UserView, "user.json"),
      user_id: user_group.user_id,
      group_id: user_group.group_id,
      membership_status:
        render_one(
          user_group.membership_status,
          MembershipStatusView,
          "membership_status.json"
        )
    }
  end
end
