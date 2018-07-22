defmodule Travenger.Groups.MembershipStatus do
  @moduledoc """
  Group schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.Membership

  schema "membership_statuses" do
    field(:status, MembershipStatusEnum, default: :pending)
    field(:approved_at, :naive_datetime)
    field(:banned_at, :naive_datetime)
    field(:invited_at, :naive_datetime)
    field(:joined_at, :naive_datetime)
    field(:unbanned_at, :naive_datetime)
    field(:accepted_at, :naive_datetime)

    belongs_to(:membership, Membership)

    timestamps()
  end

  def update_changeset(membership_status, attrs) do
    membership_status
    |> cast(attrs, [:status])
    |> validate_required(:status)
    |> put_change(:approved_at, DateTime.utc_now())
  end
end
