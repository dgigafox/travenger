defmodule TravengerWeb.Api.V1.FollowingView do
  use TravengerWeb, :view

  alias __MODULE__
  alias Travenger.Accounts.Following
  alias TravengerWeb.Api.V1.GroupView
  alias TravengerWeb.Api.V1.UserView

  def render("show.json", %{following: following}) do
    %{data: render_one(following, FollowingView, "following.json")}
  end

  def render("following.json", %{following: %Following{type: :user} = f}) do
    %{
      id: f.id,
      user: render_one(f.user, UserView, "user.json"),
      followed_user: render_one(f.followed_user, UserView, "user.json")
    }
  end

  def render("following.json", %{following: %Following{type: :group} = f}) do
    %{
      id: f.id,
      user: render_one(f.user, UserView, "user.json"),
      followed_group: render_one(f.followed_group, GroupView, "group.json")
    }
  end
end
