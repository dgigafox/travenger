defmodule TravengerWeb.Api.V1.InvitationView do
  use TravengerWeb, :view

  alias __MODULE__
  alias Scrivener.Page

  alias TravengerWeb.Api.V1.{
    GroupView,
    UserView
  }

  def render("index.json", %{invitations: %Page{} = invitations}) do
    entries = render_many(invitations.entries, InvitationView, "invitation.json")
    %{data: %{invitations | entries: entries}}
  end

  def render("show.json", %{invitation: invitation}) do
    %{data: render_one(invitation, InvitationView, "invitation.json")}
  end

  def render("invitation.json", %{invitation: invitation}) do
    %{
      id: invitation.id,
      type: invitation.type,
      status: invitation.status,
      user_id: invitation.user_id,
      group_id: invitation.group_id,
      user: render_one(invitation.user, UserView, "user.json"),
      group: render_one(invitation.group, GroupView, "group.json")
    }
  end
end
