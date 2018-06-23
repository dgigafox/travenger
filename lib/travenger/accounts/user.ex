defmodule Travenger.Accounts.User do
  @moduledoc """
  User schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.UserGroup
  alias Travenger.Groups.Group

  alias Travenger.Posts.{
    Blog,
    Event
  }

  schema "users" do
    field(:email, :string)
    field(:provider, :string)
    field(:token, :string)
    # user info
    field(:name, :string)
    field(:image_url, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:gender, :string)

    many_to_many(:groups, Group, join_through: UserGroup)
    has_many(:events, Event)
    has_many(:blogs, Blog)

    timestamps()
  end

  @user_attrs ~w(email provider token name image_url first_name last_name
                gender)a

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, @user_attrs)
    |> validate_required(@user_attrs -- [:provider, :token])
  end
end
