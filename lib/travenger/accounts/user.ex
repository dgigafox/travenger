defmodule Travenger.Accounts.User do
  @moduledoc """
  User schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.{
    Following,
    Membership
  }

  alias Travenger.Posts.{
    Blog,
    Event
  }

  @derive {Poison.Encoder, only: [:name]}

  schema "users" do
    field(:email, :string)
    field(:provider, :string)
    field(:token, :string)
    # user info
    field(:name, :string)
    field(:image_url, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:gender, GenderTypeEnum)

    has_many(:groups, Membership)
    has_many(:events, Event)
    has_many(:blogs, Blog)
    has_many(:followed_users, Following)
    has_many(:followers, Following)

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
