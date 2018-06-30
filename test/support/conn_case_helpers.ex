defmodule TravengerWeb.ConnCaseHelpers do
  @moduledoc """
  Helpers for ConnCase
  """

  def render_json(view, template, assigns) do
    template
    |> view.render(assigns)
    |> format_json()
  end

  @doc """
  Render a paginated struct by mapping a list to a struct function
  """
  def render_paginated(list, struct_func) do
    Enum.map(list, fn struct ->
      struct_func.(struct)
    end)
  end

  # Private functions

  defp format_json(data) do
    data
    |> Poison.encode!()
    |> Poison.decode!()
  end
end
