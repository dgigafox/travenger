defmodule TravengerSeeder do
  @moduledoc """
  Data seed for testing
  """
  import String
  import Travenger.Helpers.Strings

  alias Travenger.Accounts

  def seed do
    Map.new()
    |> create_users()
  end

  def create_users(params) do
    users =
      [
        {"Darren", "Gegantino", :male},
        {"Shirly", "Gegantino", :female}
      ]
      |> Enum.map(&create_user(&1))

    Map.put(params, :users, users)
  end

  def create_user({first_name, last_name, gender}) do
    attrs = %{
      email: downcase(first_name) <> downcase(last_name) <> "@email.com",
      provider: "facebook",
      token: random_string(40),
      name: first_name <> " " <> last_name,
      image_url: "http://graph.facebook.com/" <> random_string(17) <> "/picture?type=square",
      first_name: first_name,
      last_name: last_name,
      gender: gender
    }

    {:ok, user} = Accounts.auth_or_register_user(attrs)
    user
  end
end
