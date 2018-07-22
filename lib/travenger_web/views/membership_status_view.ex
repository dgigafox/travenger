defmodule TravengerWeb.MembershipStatusView do
  use TravengerWeb, :view

  alias __MODULE__

  def render("show.json", %{membership_status: membership_status}) do
    %{data: render_one(membership_status, MembershipStatusView, "membership_status.json")}
  end

  def render("membership_status.json", %{membership_status: membership_status}) do
    %{
      id: membership_status.id,
      status: membership_status.status,
      approved_at: membership_status.approved_at,
      banned_at: membership_status.banned_at,
      invited_at: membership_status.invited_at,
      joined_at: membership_status.joined_at,
      unbanned_at: membership_status.unbanned_at,
      accepted_at: membership_status.accepted_at
    }
  end
end
