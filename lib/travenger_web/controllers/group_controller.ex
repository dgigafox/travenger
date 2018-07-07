defmodule TravengerWeb.GroupController do
  use TravengerWeb, :controller

  import Travenger.Helpers.Utils

  alias Travenger.Groups
  alias Travenger.Groups.Group

  def create(conn, params) do
    with params <- string_keys_to_atom(params),
         {:ok, group} <- Groups.create_group(params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{group: group})
    end
  end
end
