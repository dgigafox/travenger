defmodule Travenger.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Travenger.Repo

  alias Travenger.Posts.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  alias Travenger.Posts.Blog

  @doc """
  Returns the list of blogs.

  ## Examples

      iex> list_blogs()
      [%Blog{}, ...]

  """
  def list_blogs do
    Repo.all(Blog)
  end

  @doc """
  Gets a single blog.

  Raises `Ecto.NoResultsError` if the Blog does not exist.

  ## Examples

      iex> get_blog!(123)
      %Blog{}

      iex> get_blog!(456)
      ** (Ecto.NoResultsError)

  """
  def get_blog!(id), do: Repo.get!(Blog, id)

  @doc """
  Creates a blog.

  ## Examples

      iex> create_blog(%{field: value})
      {:ok, %Blog{}}

      iex> create_blog(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_blog(attrs \\ %{}) do
    %Blog{}
    |> Blog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a blog.

  ## Examples

      iex> update_blog(blog, %{field: new_value})
      {:ok, %Blog{}}

      iex> update_blog(blog, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_blog(%Blog{} = blog, attrs) do
    blog
    |> Blog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Blog.

  ## Examples

      iex> delete_blog(blog)
      {:ok, %Blog{}}

      iex> delete_blog(blog)
      {:error, %Ecto.Changeset{}}

  """
  def delete_blog(%Blog{} = blog) do
    Repo.delete(blog)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blog changes.

  ## Examples

      iex> change_blog(blog)
      %Ecto.Changeset{source: %Blog{}}

  """
  def change_blog(%Blog{} = blog) do
    Blog.changeset(blog, %{})
  end
end
