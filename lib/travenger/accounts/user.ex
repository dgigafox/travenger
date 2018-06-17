defmodule Travenger.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

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
    field(:image_url, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:gender, :string)

    has_many(:groups, Group)
    has_many(:events, Event)
    has_many(:blogs, Blog)

    timestamps()
  end

  @user_attrs ~w(email token provider image_url first_name last_name gender)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @user_attrs)
    |> validate_required([:email])
  end
end
