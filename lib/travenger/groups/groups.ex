defmodule Travenger.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  import Travenger.Helpers.Queries
  import Travenger.Helpers.Queries.Membership

  alias Ecto.Multi

  alias Travenger.Accounts.{
    Membership,
    User
  }

  alias Travenger.Groups.{
    Group,
    MembershipStatus
  }

  alias Travenger.Repo

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups(params \\ %{}) do
    Group
    |> where_user(params)
    |> Repo.paginate(params)
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
  def get_group(id), do: Repo.get(Group, id)

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
    group
    |> Group.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
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

  defp update_membership_status(%{membership_status: mstatus}, membership) do
    membership
    |> Map.put(:membership_status, mstatus)
    |> Membership.approve_changeset()
    |> Repo.update()
  end

  @doc """
  Find admin
  """
  def find_group_admin(params) do
    Membership
    |> where_group(params)
    |> where_user(params)
    |> where_admin(params)
    |> Repo.one()
  end

  @doc """
  Get membership via id
  """
  def get_membership(id), do: Repo.get(Membership, id)
end
