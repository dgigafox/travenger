defmodule Travenger.Helpers.Utils do
  @moduledoc """
  Helper Util Functions
  """

  @doc """
  Converts string to atom
  """
  def to_atom(string) when is_binary(string) do
    String.to_atom(string)
  end

  def to_atom(atom) when is_atom(atom), do: atom

  @doc """
  Converts map string keys to atom keys
  """
  def string_keys_to_atom(map) do
    for {key, val} <- map, into: %{} do
      {to_atom(key), val}
    end
  end
end
