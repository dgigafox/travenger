defmodule TravengerWeb.ChangesetView do
  @moduledoc """
  Changeset View
  """

  use TravengerWeb, :view

  def render("error.json", %{changeset: ch}) do
    %{errors: get_errors(ch)}
  end

  # Private functions

  defp get_errors(%Ecto.Changeset{} = ch) do
    parse_changes(ch) ++ parse_errors(ch)
  end

  # returns list of errors in nested changesets
  defp parse_changes(%{changes: changes}) do
    changes
    |> Enum.map(&process_changes(&1))
    |> List.flatten()
  end
  defp parse_changes(_), do: []

  defp process_changes({_model, %Ecto.Changeset{} = ch}) do
    get_errors(ch)
  end
  defp process_changes({_, _}), do: []

  defp parse_errors(ch) do
    Enum.map(ch.errors, fn {field, detail} ->
      %{"#{field}": render_detail(detail)}
    end)
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end
  defp render_detail(message), do: message
end
