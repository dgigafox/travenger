defmodule Travenger.Posts.BlogTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Posts.Blog

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = Blog.changeset(%Blog{}, params_for(:blog))

      assert ch.valid?
    end
  end
end
