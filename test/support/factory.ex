defmodule Travenger.Factory do
  @moduledoc """
  Factory lib for creating records and building schemas
  """
  use ExMachina.Ecto, repo: Travenger.Repo

  alias Travenger.Accounts.User

  def user_factory do
    email = sequence(:email, &"email-#{&1}@example.com")

    %User{
      email: email,
      image_url: "http://graph.facebook.com/10216277902323229/picture?type=square",
      first_name: "Darren",
      last_name: "Gegantino",
      gender: "male",
      token:
        "EAAbTLLNZAHhUBAO2GaawhTqbrKAmhfNGdxtEAGVZCYFZAHSCZCfiTnLp1Tvq7VqkRUqQK9zCoXZAUnN9dNe9ZAIPhk3kO4W4H31ZAJVEEiqwLZABmQyQCwwCdKEPU64E2PDaPO3qL0tRy3ZAMPDOzRXL2rq8580dnbFwnZA67oioRHdwZDZD",
      provider: "facebook"
    }
  end
end
