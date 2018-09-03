defmodule Travenger.Accounts.Following do
  @moduledoc """
  Following Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User

  schema "followings" do
    belongs_to(:user, User)
    belongs_to(:followed_user, User)
    timestamps()
  end

  @doc false
  def changeset(following, attrs \\ %{}) do
    following
    |> cast(attrs, [:user_id])
    |> cast_assoc(:user, required: true)
    |> cast_assoc(:followed_user, required: true)
    |> assoc_constraint(:user)
    |> assoc_constraint(:followed_user)
  end
end
