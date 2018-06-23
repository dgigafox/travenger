defmodule Travenger.Helpers.Queries do
  @moduledoc """
  Queries helper
  """
  import Ecto.Query

  def sort_by(query, _params) do
    order_by(query, desc: :id)
  end

  def where_id(query, %{id: id}) do
    query
    |> where([q], q.id == ^id)
  end

  def where_id(query, _params), do: query

  def where_name(query, %{name: name}) do
    where(query, [q], q.name == ^name)
  end

  def where_name(query, _params), do: query

  def where_email(query, %{email: email}) do
    where(query, [q], q.email == ^email)
  end

  def where_email(query, _params), do: query
end
