defmodule TravengerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  """

  use TravengerWeb, :controller

  alias Ecto.Changeset

  alias TravengerWeb.{
    ChangesetView,
    ErrorView
  }

  @doc """
  Return not found error
  """
  def call(conn, nil) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, "404.json", [])
  end

  @doc """
  Return changeset errors
  """
  def call(conn, {:error, %Changeset{} = ch}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ChangesetView, "error.json", changeset: ch)
  end
end
