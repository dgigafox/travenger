defmodule TravengerWeb.UserView do
  use TravengerWeb, :view

  alias __MODULE__

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      token: user.token
    }
  end
end
