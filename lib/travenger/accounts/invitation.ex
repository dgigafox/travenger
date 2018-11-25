defmodule Travenger.Accounts.Invitation do
  @moduledoc """
  Invitation Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  alias Travenger.Groups.Group
  alias Travenger.Posts.Event

  @invitation_attrs ~w(status type)a

  schema "invitations" do
    field(:status, InvitationStatusEnum, default: :pending)
    field(:type, InvitationTypeEnum)

    belongs_to(:user, User)
    belongs_to(:group, Group)
    belongs_to(:event, Event)

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs \\ %{}) do
    invitation
    |> cast(attrs, @invitation_attrs)
    |> cast_assoc(:user, required: true)
    |> validate_required(@invitation_attrs)
    |> validate_assoc()
  end

  def accept_changeset(invitation, attrs \\ %{}) do
    invitation
    |> cast(attrs, [:status])
    |> validate_assoc()
    |> put_change(:status, :accepted)
  end

  def cancel_changeset(invitation, attrs \\ %{}) do
    change(invitation, %{status: :cancelled})
  end

  defp validate_assoc(ch) do
    case get_field(ch, :type) do
      nil -> ch
      type -> cast_assoc(ch, type, required: true)
    end
  end
end
