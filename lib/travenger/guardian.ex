defmodule Travenger.Guardian do
  @moduledoc """
  Generates and validates token
  """
  use Guardian, otp_app: :travenger

  alias Travenger.Accounts
  alias Travenger.Accounts.User

  @auth_token_attrs ~w(id)a

  @doc """
  Generates authorization token for User
  """
  def subject_for_token(%User{} = user, %{"auth" => 1}) do
    {:ok, Map.take(user, @auth_token_attrs)}
  end

  def resource_from_claims(%{"auth" => 1, "sub" => %{"id" => id}}) when is_integer(id) do
    case Accounts.get_user(id) do
      nil -> {:error, :invalid_user}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(%{"sub" => sub}), do: {:ok, sub}
end
