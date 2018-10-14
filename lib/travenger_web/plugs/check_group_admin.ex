defmodule Travenger.Plugs.CheckGroupAdmin do
  @moduledoc """
  Plug for checking if the current user is authorized to access the group.
  If no options are passed, the default roles to be checked are admin and creator.
  """

  @behaviour Plug

  import Plug.Conn
  import Travenger.Helpers.Utils

  alias Phoenix.Controller
  alias Travenger.Accounts
  alias TravengerWeb.ErrorView

  @admin_roles ~w(creator admin)a

  def init(opts), do: opts

  def call(%{assigns: %{user: user}} = conn, roles) when is_list(roles) do
    roles =
      case roles do
        [] -> @admin_roles
        roles -> roles
      end

    conn.params
    |> string_keys_to_atom()
    |> Map.put(:user_id, user.id)
    |> Map.put(:roles, roles)
    |> Accounts.find_membership()
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
