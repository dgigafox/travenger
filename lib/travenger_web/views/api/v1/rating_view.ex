defmodule TravengerWeb.Api.V1.RatingView do
  use TravengerWeb, :view

  alias __MODULE__

  alias TravengerWeb.Api.V1.{
    GroupView,
    UserView
  }

  def render("show.json", %{rating: rating}) do
    %{data: render_one(rating, RatingView, "rating.json")}
  end

  def render("rating.json", %{rating: rating}) do
    %{
      id: rating.id,
      author: render_one(rating.author, UserView, "user.json"),
      followed_group: render_one(rating.group, GroupView, "group.json"),
      rating: rating.rating
    }
  end
end
