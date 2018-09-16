defmodule Travenger.TestHelpers do
  @moduledoc """
  Test helper for building conn
  """
  import Travenger.Helpers.Token

  alias Travenger.Repo

  def build_user_conn(user, build_conn, put_req_header) do
    {:ok, token} = generate_auth_token(user)
    put_req_header.(build_conn.(), "authorization", "Bearer " <> token)
  end

  def get_assoc(struct, key) do
    struct
    |> Repo.preload(key)
    |> Map.get(key)
  end
end
