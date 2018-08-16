defmodule Travenger.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Travenger.Helpers.Queries

  alias Travenger.Accounts.Invitation
  alias Travenger.Accounts.User
  alias Travenger.Groups.Group
  alias Travenger.Repo

  @doc """
  Authenticate or Register user via Facebook
  """
  def auth_or_register_user(%{email: email} = attrs) do
    attrs
    |> find_user()
    |> case do
      nil -> %User{email: email}
      user -> user
    end
    |> User.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(attrs \\ %{}) do
    User
    |> where_gender(attrs)
    |> Repo.paginate(attrs)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def find_user(params) do
    User
    |> where_id(params)
    |> where_name(params)
    |> where_email(params)
    |> Repo.one()
  end

  def get_user(id), do: Repo.get(User, id)

  def create_group_invitation(%User{} = user, %Group{} = group) do
    %Invitation{
      user: user,
      group: group,
      type: :group
    }
    |> Invitation.changeset()
    |> Repo.insert()
  end
end
