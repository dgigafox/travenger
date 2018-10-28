defmodule Travenger.Groups.MembershipStatus do
  @moduledoc """
  Group schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.Membership

  @attrs ~w(status approved_at banned_at invited_at
  joined_at unbanned_at accepted_at)a

  schema "membership_statuses" do
    field(:status, MembershipStatusEnum, default: :pending)
    field(:approved_at, :naive_datetime)
    field(:banned_at, :naive_datetime)
    field(:invited_at, :naive_datetime)
    field(:joined_at, :naive_datetime)
    field(:unbanned_at, :naive_datetime)
    field(:accepted_at, :naive_datetime)
    field(:removed_at, :naive_datetime)

    belongs_to(:membership, Membership)

    timestamps()
  end

  def changeset(membership_status, attrs \\ %{}) do
    membership_status
    |> cast(attrs, @attrs)
    |> validate_required(:status)
  end

  def approve_changeset(membership_status) do
    membership_status
    |> change()
    |> put_change(:status, :approved)
    |> put_change(:approved_at, DateTime.utc_now())
  end

  def remove_changeset(membership_status) do
    membership_status
    |> change()
    |> put_change(:status, :removed)
    |> put_change(:removed_at, DateTime.utc_now())
  end
end
