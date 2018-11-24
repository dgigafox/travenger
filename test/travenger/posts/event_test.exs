defmodule Travenger.Posts.EventTest do
  use ExUnit.Case, async: true

  import Travenger.Factory
  alias Travenger.Posts.Event

  describe "changeset/2" do
    test "returns a valid changeset" do
      ch = Event.changeset(%Event{}, params_for(:event))

      assert ch.valid?
    end
  end
end
