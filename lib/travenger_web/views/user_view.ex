defmodule TravengerWeb.UserView do
  use TravengerWeb, :view

  alias __MODULE__
  alias Scrivener.Page

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("index.json", %{users: %Page{} = users}) do
    entries = render_many(users.entries, UserView, "user.json")
    %{data: %{users | entries: entries}}
  end

  def render("token.json", %{token: token}) do
    %{data: %{token: token}}
  end

  def render("user.json", %{user: user}) do
    %{
      first_name: user.first_name,
      last_name: user.last_name,
      image_url: user.image_url,
      gender: user.gender,
      token: user.token
    }
  end
end
