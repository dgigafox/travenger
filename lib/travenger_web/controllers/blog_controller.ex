defmodule TravengerWeb.BlogController do
  use TravengerWeb, :controller

  alias Travenger.Posts
  alias Travenger.Posts.Blog

  def index(conn, _params) do
    blogs = Posts.list_blogs()
    render(conn, "index.html", blogs: blogs)
  end

  def new(conn, _params) do
    changeset = Posts.change_blog(%Blog{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"blog" => blog_params}) do
    case Posts.create_blog(blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, "Blog created successfully.")
        |> redirect(to: blog_path(conn, :show, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    blog = Posts.get_blog!(id)
    render(conn, "show.html", blog: blog)
  end

  def edit(conn, %{"id" => id}) do
    blog = Posts.get_blog!(id)
    changeset = Posts.change_blog(blog)
    render(conn, "edit.html", blog: blog, changeset: changeset)
  end

  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Posts.get_blog!(id)

    case Posts.update_blog(blog, blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, "Blog updated successfully.")
        |> redirect(to: blog_path(conn, :show, blog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", blog: blog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    blog = Posts.get_blog!(id)
    {:ok, _blog} = Posts.delete_blog(blog)

    conn
    |> put_flash(:info, "Blog deleted successfully.")
    |> redirect(to: blog_path(conn, :index))
  end
end
