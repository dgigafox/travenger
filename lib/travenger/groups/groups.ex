defmodule Travenger.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  import Travenger.Helpers.Queries
  import Travenger.Helpers.Queries.Membership

  alias Ecto.Multi

  alias Travenger.Accounts.{
    Invitation,
    Membership,
    User
  }

  alias Travenger.Groups.{
    Group,
    MembershipStatus
  }

  alias Travenger.Repo

  @member_limit_error "cannot set limit less than current number of members"
  @member_roles ~w(creator admin member)a

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups(params \\ %{}) do
    Group
    |> where_keyword(params)
    |> where_name(params)
    |> where_user(params)
    |> where_not_deleted(params)
    |> Repo.paginate(params)
  end

  @doc """
  Deletes a Group. Updates deleted_at.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    group
    |> Group.delete_changeset()
    |> Repo.update()
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group(id) do
    params = %{id: id}

    Group
    |> where_id(params)
    |> where_not_deleted(params)
    |> Repo.one()
  end

  @doc """
  Creates a group.
  """
  def create_group(user, attrs) do
    %Group{
      user: user
    }
    |> Repo.preload([:members])
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    with {:ok, group} <- verify_member_limit(group, attrs) do
      group
      |> Group.update_changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end

  @doc """
  Joins a group
  """
  def join_group(%User{} = user, %Group{} = group) do
    %Membership{
      user: user,
      group: group
    }
    |> Repo.preload([:membership_status])
    |> Membership.join_changeset()
    |> Repo.insert()
  end

  @doc """
  Approves a join request
  """
  def approve_join_request(%Membership{} = membership) do
    m =
      membership
      |> Repo.preload([:membership_status, :user, :group])

    params = %{status: :approved}

    Multi.new()
    |> Multi.run(:member_limit_status, &is_full?(&1, m.group))
    |> Multi.update(
      :membership_status,
      MembershipStatus.update_changeset(m.membership_status, params)
    )
    |> Multi.run(:membership, &update_membership_status(&1, m))
    |> Repo.transaction()
    |> case do
      {:error, _ops, val, _ch} ->
        {:error, val}

      {:ok, %{membership: membership}} ->
        {:ok, membership}
    end
  end

  @doc """
  Get membership via id
  """
  def get_membership(id), do: Repo.get(Membership, id)

  @doc """
  Invite a user to be a member of the group
  """
  def invite(%User{} = user, %Group{} = group) do
    Multi.new()
    |> Multi.run(:group_invitation, &find_group_invitation(&1, user, group))
    |> Multi.insert(
      :membership_status,
      %Membership{
        user: user,
        group: group
      }
      |> Repo.preload([:membership_status])
      |> Membership.invite_changeset()
    )
    |> Multi.insert(
      :invitation,
      %Invitation{
        user: user,
        group: group,
        type: :group
      }
      |> Invitation.changeset()
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{membership_status: mstatus}} -> {:ok, mstatus}
      {:error, _ops, ch, _c} -> {:error, ch}
    end
  end

  def invite(_, %Group{}), do: {:error, "invalid user"}
  def invite(%User{}, _), do: {:error, "invalid group"}
  def invite(_, _), do: {:error, "invalid user and group"}

  ###########################################################################
  # => Private Functions
  ###########################################################################
  defp is_full?(_, %Group{member_limit: nil}), do: {:ok, "not yet full"}

  defp is_full?(_, %Group{member_limit: limit} = group) do
    case count_members(group) == limit do
      true -> {:error, "maximum number of members reached"}
      _ -> {:ok, "not yet full"}
    end
  end

  defp verify_member_limit(group, %{member_limit: limit}) do
    case limit >= count_members(group) do
      true -> {:ok, group}
      _ -> {:error, @member_limit_error}
    end
  end

  defp verify_member_limit(group, _attrs), do: {:ok, group}

  defp count_members(group) do
    Membership
    |> where_group(%{group_id: group.id})
    |> where_roles(%{roles: @member_roles})
    |> Repo.aggregate(:count, :id)
  end

  defp update_membership_status(%{membership_status: mstatus}, membership) do
    membership
    |> Map.put(:membership_status, mstatus)
    |> Membership.approve_changeset()
    |> Repo.update()
  end

  defp find_group_invitation(_, user, group) do
    Invitation
    |> where_user(%{user_id: user.id})
    |> where_group(%{group_id: group.id})
    |> last()
    |> Repo.one()
    |> case do
      nil -> {:ok, "no existing invitation"}
      invitation -> {:error, "has #{invitation.status} invitation"}
    end
  end
end
