defmodule Travenger.Plugs.RequireAuth do
  @moduledoc """
  Authentication Plug
  """

  @behaviour Plug

  import Plug.Conn
  import Travenger.Guardian

  alias Phoenix.Controller
  alias TravengerWeb.ErrorView

  def init(opts), do: opts

  def call(conn, _) do
    conn
    |> get_req_header("authorization")
    |> parse_auth_token()
    |> get_resource()
    |> assign_to_conn(conn)
    |> check_errors(conn)
  end

  ###########################################################################
  # => Private Functions
  ###########################################################################
  defp parse_auth_token(["Bearer " <> token]) do
    resource_from_token(token)
  end

  defp parse_auth_token([]), do: {:ok, %{}, %{}}
  defp parse_auth_token(_), do: {:error, "Invalid token format"}

  defp get_resource({:ok, res, %{"auth" => 1}}) do
    %{user: res}
  end

  defp get_resource({:ok, %{}, %{}}), do: %{}
  defp get_resource({:ok, _res, _}), do: {:error, "Invalid token"}

  defp get_resource({:error, %CaseClauseError{}}) do
    {:error, "Invalid token"}
  end

  defp get_resource({:error, msg}), do: {:error, msg}

  defp assign_to_conn(%{user: user}, conn) do
    assign(conn, :user, user)
  end

  defp assign_to_conn(%{}, _conn) do
    {:error, "User unauthorized"}
  end

  defp assign_to_conn({:error, msg}, _), do: {:error, msg}

  defp check_errors({:error, _msg}, conn) do
    conn
    |> put_status(401)
    |> Controller.render(ErrorView, "401.json")
    |> halt()
  end

  defp check_errors(_, conn), do: conn
end
