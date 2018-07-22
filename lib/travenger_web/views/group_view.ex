defmodule TravengerWeb.GroupView do
  use TravengerWeb, :view

  alias __MODULE__

  def render("show.json", %{group: group}) do
    %{data: render_one(group, GroupView, "group.json")}
  end

  def render("group.json", %{group: group}) do
    %{
      id: group.id,
      name: group.name,
      image_url: group.image_url,
      description: group.description
    }
  end
end
