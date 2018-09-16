defmodule Travenger.Helpers.Queries.Notification do
  @moduledoc """
  Notifications Queries helper
  """
  import Ecto.Query

  def where_notifier(query, %{notifier_id: id}) do
    where(query, [q], q.notifier_id == ^id)
  end

  def where_notifier(query, _), do: query
end
