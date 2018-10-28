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

    belongs_to(:membership, Membership)

    timestamps()
  end

  def changeset(membership_status, attrs \\ %{}) do
    membership_status
    |> cast(attrs, @attrs)
    |> validate_required(:status)
  end

  def update_changeset(membership_status, attrs) do
    membership_status
    |> cast(attrs, [:status])
    |> validate_required(:status)
    |> put_change(:approved_at, DateTime.utc_now())
  end
end
