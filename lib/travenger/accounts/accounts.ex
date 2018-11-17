defmodule Travenger.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Travenger.Helpers.Queries
  import Travenger.Helpers.Queries.Membership

  alias Ecto.Multi

  alias Travenger.Accounts.{
    Following,
    Invitation,
    User
  }

  alias Travenger.Groups
  alias Travenger.Groups.Membership
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
    |> where_keyword(attrs)
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

  def find_invitation(params) do
    Invitation
    |> where_id(params)
    |> where_status(params)
    |> where_type(params)
    |> where_group(params)
    |> where_user(params)
    |> Repo.one()
  end

  def find_membership(params) do
    Membership
    |> where_user(params)
    |> where_group(params)
    |> where_roles(params)
    |> Repo.one()
  end

  def get_user(id), do: Repo.get(User, id)

  def list_invitations(params \\ %{}) do
    Invitation
    |> sort_by(params)
    |> where_user(params)
    |> where_group(params)
    |> where_type(params)
    |> where_status(params)
    |> preload([:user, :group])
    |> Repo.paginate(params)
  end

  def accept_invitation(%Invitation{type: :group} = invitation) do
    invitation = Repo.preload(invitation, [:user, :group])

    Multi.new()
    |> Multi.run(:member_limit_status, &Groups.is_full?(&1, invitation.group))
    |> Multi.update(:invitation, Invitation.accept_changeset(invitation))
    |> Multi.run(:membership, &update_membership(&1))
    |> Repo.transaction()
    |> case do
      {:ok, %{invitation: invitation}} -> {:ok, invitation}
      {:error, _ops, ch, _c} -> {:error, ch}
    end
  end

  def accept_invitation(_), do: {:error, "invalid invitation"}

  def follow_user(%User{} = follower, %User{} = followed_user) do
    with {:ok} <- compare_user(follower, followed_user) do
      %Following{user: follower, followed_user: followed_user}
      |> Following.changeset(%{type: :user})
      |> Repo.insert()
    end
  end

  def follow_user(_, %User{}), do: {:error, "invalid follower"}
  def follow_user(%User{}, _), do: {:error, "invalid followed user"}
  def follow_user(_, _), do: {:error, "invalid params"}

  ###########################################################################
  # => Private Functions
  ###########################################################################
  defp compare_user(follower, followed_user) do
    case follower.id == followed_user.id do
      true -> {:error, "followed user is the same with the follower"}
      _ -> {:ok}
    end
  end

  defp update_membership(%{invitation: invitation}) do
    with {:ok, user} <- get_assoc(invitation, :user),
         {:ok, group} <- get_assoc(invitation, :group),
         {:ok, membership} <- find_membership(user, group) do
      membership
      |> Repo.preload([:user, :group, :membership_status])
      |> Membership.update_changeset(%{
        role: :member,
        membership_status: %{
          status: :accepted,
          accepted_at: DateTime.utc_now()
        }
      })
      |> Repo.update()
    end
  end

  defp find_membership(user, group) do
    params = %{
      user_id: user.id,
      group_id: group.id
    }

    case find_membership(params) do
      nil -> {:error, "no membership found"}
      membership -> {:ok, membership}
    end
  end

  defp get_assoc(struct, key) do
    struct
    |> Repo.preload([key])
    |> Map.get(key)
    |> case do
      nil -> {:error, "no association found"}
      assoc -> {:ok, assoc}
    end
  end
end
