defmodule Travenger.Helpers.Strings do
  @moduledoc """
  Strings Helper
  """
  def random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  def gen_code(prefix \\ nil) do
    prefix = prefix || random_string(4)
    "#{prefix}-#{random_string(4)}-#{random_string(4)}"
  end

  @doc """
  Converts literal date string to NaiveDateTime format
  """
  def string_to_naive_datetime(date) do
    with {:ok, date} <- Date.from_iso8601(date) do
      NaiveDateTime.new(date, ~T[00:00:00])
    end
  end
end
