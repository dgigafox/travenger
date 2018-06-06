defmodule Travenger.PostsTest do
  use Travenger.DataCase

  alias Travenger.Posts

  describe "events" do
    alias Travenger.Posts.Event

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Posts.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Posts.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Posts.create_event(@valid_attrs)
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Posts.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_event(event, @invalid_attrs)
      assert event == Posts.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Posts.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Posts.change_event(event)
    end
  end

  describe "blogs" do
    alias Travenger.Posts.Blog

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def blog_fixture(attrs \\ %{}) do
      {:ok, blog} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_blog()

      blog
    end

    test "list_blogs/0 returns all blogs" do
      blog = blog_fixture()
      assert Posts.list_blogs() == [blog]
    end

    test "get_blog!/1 returns the blog with given id" do
      blog = blog_fixture()
      assert Posts.get_blog!(blog.id) == blog
    end

    test "create_blog/1 with valid data creates a blog" do
      assert {:ok, %Blog{} = blog} = Posts.create_blog(@valid_attrs)
      assert blog.title == "some title"
    end

    test "create_blog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_blog(@invalid_attrs)
    end

    test "update_blog/2 with valid data updates the blog" do
      blog = blog_fixture()
      assert {:ok, blog} = Posts.update_blog(blog, @update_attrs)
      assert %Blog{} = blog
      assert blog.title == "some updated title"
    end

    test "update_blog/2 with invalid data returns error changeset" do
      blog = blog_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_blog(blog, @invalid_attrs)
      assert blog == Posts.get_blog!(blog.id)
    end

    test "delete_blog/1 deletes the blog" do
      blog = blog_fixture()
      assert {:ok, %Blog{}} = Posts.delete_blog(blog)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_blog!(blog.id) end
    end

    test "change_blog/1 returns a blog changeset" do
      blog = blog_fixture()
      assert %Ecto.Changeset{} = Posts.change_blog(blog)
    end
  end
end
