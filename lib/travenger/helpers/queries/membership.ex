defmodule Travenger.Helpers.Queries.Membership do
  @moduledoc """
  Membership Queries helper
  """
  import Ecto.Query

  def where_admin(query, _params) do
    where(query, [q], q.role == ^:creator or q.role == ^:admin)
  end
end
