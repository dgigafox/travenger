defmodule Travenger.Plugs.CheckGroupAdmin do
  @moduledoc """
  Plug for checking if the current user is authorized to access the group
  """

  @behaviour Plug

  import Plug.Conn
  import Travenger.Helpers.Utils

  alias Phoenix.Controller
  alias Travenger.Groups
  alias TravengerWeb.ErrorView

  def init(opts), do: opts

  def call(%{assigns: %{user: user}} = conn, _) do
    conn.params
    |> string_keys_to_atom()
    |> Map.put(:user_id, user.id)
    |> Groups.find_group_admin()
    |> case do
      nil ->
        conn
        |> put_status(403)
        |> Controller.render(ErrorView, "403.json")
        |> halt()

      _ ->
        conn
    end
  end
end
