defmodule Travenger.Groups.MembershipStatus do
  @moduledoc """
  Group schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Travenger.Accounts.UserGroup

  @group_attrs ~w(name image_url description)

  schema "membership_statuses" do
    field(:status, MembershipStatusEnum, default: :pending)
    field(:approved_at, :naive_datetime)
    field(:banned_at, :naive_datetime)
    field(:invited_at, :naive_datetime)
    field(:joined_at, :naive_datetime)
    field(:unbanned_at, :naive_datetime)
    field(:accepted_at, :naive_datetime)

    belongs_to(:membership, UserGroup)

    timestamps()
  end
end
