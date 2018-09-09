defmodule Travenger.Helpers.StringsTest do
  use ExUnit.Case, async: true

  import Travenger.Helpers.Strings

  describe "random_string/1" do
    length = 4
    assert String.length(random_string(length)) == length
  end

  describe "gen_code/1" do
    @prefix "prefix"

    test "returns a randomly-generated string" do
      assert @prefix <> _ = gen_code(@prefix)
      assert is_binary(gen_code())
    end
  end
end
