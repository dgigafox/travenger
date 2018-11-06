defmodule Travenger.Groups.RatingTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Groups.Rating

  describe "changeset/2" do
    test "returns a valid changeset" do
      rating = build(:group_rating)
      ch = Rating.changeset(rating, %{rating: 5})

      assert ch.valid?
    end

    test "returns invalid changeset for invalid rating" do
      ch = Rating.changeset(build(:group_rating), %{rating: 1.5})

      assert ch.errors == [rating: {"is invalid", [type: :integer, validation: :cast]}]
    end

    test "returns invalid changeset if rating is not within range" do
      ch = Rating.changeset(build(:group_rating), %{rating: 10})

      assert ch.errors == [rating: {"is invalid", [validation: :inclusion]}]
    end

    test "returns invalid changeset" do
      ch = Rating.changeset(%Rating{}, %{})

      expected_errors = [
        rating: {"can't be blank", [validation: :required]},
        group: {"can't be blank", [validation: :required]},
        author: {"can't be blank", [validation: :required]}
      ]

      refute ch.valid?
      assert ch.errors == expected_errors
    end
  end
end
