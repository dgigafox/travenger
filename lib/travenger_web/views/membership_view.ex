defmodule TravengerWeb.MembershipView do
  use TravengerWeb, :view

  alias __MODULE__

  alias TravengerWeb.{
    GroupView,
    MembershipStatusView,
    UserView
  }

  def render("show.json", %{membership: membership}) do
    %{data: render_one(membership, MembershipView, "membership.json")}
  end

  def render("membership.json", %{membership: membership}) do
    %{
      id: membership.id,
      group: render_one(membership.group, GroupView, "group.json"),
      role: membership.role,
      user: render_one(membership.user, UserView, "user.json"),
      user_id: membership.user_id,
      group_id: membership.group_id,
      membership_status:
        render_one(
          membership.membership_status,
          MembershipStatusView,
          "membership_status.json"
        )
    }
  end
end
