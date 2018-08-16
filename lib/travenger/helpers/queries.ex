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

  def where_keyword(query, %{search: search}) do
    where(query, [q], ilike(q.name, ^"%#{search}%"))
  end

  def where_keyword(query, _), do: query

  def where_email(query, %{email: email}) do
    where(query, [q], q.email == ^email)
  end

  def where_email(query, _params), do: query

  def where_gender(query, %{gender: gender}) do
    where(query, [q], q.gender == ^gender)
  end

  def where_gender(query, _params), do: query

  def where_group(query, %{group_id: gid}) do
    where(query, [q], q.group_id == ^gid)
  end

  def where_group(query, _params), do: query

  def where_user(query, %{user_id: uid}) do
    where(query, [q], q.user_id == ^uid)
  end

  def where_user(query, _params), do: query

  def where_status(query, %{status: status}) do
    where(query, [q], q.status == ^status)
  end

  def where_status(query, _params), do: query

  def where_type(query, %{type: type}) do
    where(query, [q], q.type == ^type)
  end

  def where_type(query, _params), do: query
end
