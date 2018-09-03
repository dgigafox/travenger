defmodule TravengerWeb.Api.V1.FollowingView do
  use TravengerWeb, :view

  alias __MODULE__
  alias TravengerWeb.Api.V1.UserView

  def render("show.json", %{following: following}) do
    %{data: render_one(following, FollowingView, "following.json")}
  end

  def render("following.json", %{following: following}) do
    %{
      id: following.id,
      user: render_one(following.user, UserView, "user.json"),
      followed_user: render_one(following.followed_user, UserView, "user.json")
    }
  end
end
