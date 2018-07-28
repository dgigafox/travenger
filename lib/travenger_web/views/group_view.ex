defmodule TravengerWeb.GroupView do
  use TravengerWeb, :view

  alias __MODULE__
  alias Scrivener.Page

  def render("show.json", %{group: group}) do
    %{data: render_one(group, GroupView, "group.json")}
  end

  def render("index.json", %{groups: %Page{} = groups}) do
    entries = render_many(groups.entries, GroupView, "group.json")
    %{data: %{groups | entries: entries}}
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
