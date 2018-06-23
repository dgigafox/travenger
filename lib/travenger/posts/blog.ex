defmodule Travenger.Posts.Blog do
  @moduledoc """
  Blog schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Travenger.Accounts.User
  schema "blogs" do
    field :title, :string

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
