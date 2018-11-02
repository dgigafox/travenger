defmodule Travenger.Accounts.Following do
  @moduledoc """
  Following Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  alias Travenger.Groups.Group

  schema "followings" do
    field(:type, ObjectTypeEnum)

    belongs_to(:user, User)
    belongs_to(:followed_user, User)
    belongs_to(:followed_group, Group)
    timestamps()
  end

  @doc false
  def changeset(following, attrs \\ %{}) do
    following
    |> cast(attrs, [:type])
    |> cast_assoc(:user, required: true)
    |> validate_required([:type])
    |> validate_assoc_by_type()
    |> unique_constraint(:user_id_followed_user_id)
    |> unique_constraint(:user_id_followed_group_id)
    |> assoc_constraint(:user)
    |> assoc_constraint(:followed_user)
    |> assoc_constraint(:followed_group)
  end

  def validate_assoc_by_type(ch) do
    case get_field(ch, :type) do
      :user -> cast_assoc(ch, :followed_user, required: true)
      :group -> cast_assoc(ch, :followed_group, required: true)
      _ -> ch
    end
  end
end
