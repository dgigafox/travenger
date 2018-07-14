defmodule Travenger.Plugs.RequireAuth do
  @moduledoc """
  Authentication Plug
  """

  @behaviour Plug

  import Plug.Conn
  import Travenger.Guardian

  def init(opts), do: opts

  def call(conn, _) do
    conn
    |> get_req_header("authorization")
    |> parse_auth_token()
    |> get_resource()
    |> assign_to_conn(conn)

  end

  ###########################################################################
  # => Private Functions
  ###########################################################################
  defp parse_auth_token("Bearer" <> token) do
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

  defp assign_to_conn(resource, conn) do
    IO.inspect resource
    conn
  end
end