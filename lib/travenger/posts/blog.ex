defmodule Travenger.Posts.Blog do
  use Ecto.Schema
  import Ecto.Changeset


  schema "blogs" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
