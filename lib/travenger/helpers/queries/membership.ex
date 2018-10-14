defmodule Travenger.Helpers.Queries.Membership do
  @moduledoc """
  Membership Queries helper
  """
  import Ecto.Query

  def where_roles(query, %{roles: roles}) when is_list(roles) do
    where(query, [q], q.role in ^roles)
  end

  def where_roles(query, _), do: query
end
