defmodule Travenger.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false

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
  def list_groups do
    Repo.all(Group)
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
    |> Group.changeset(attrs)
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
  def approve_join_request(%Membership{membership_status: mstatus} = m) do
    Multi.new()
    |> Multi.update(
      :membership_status,
      MembershipStatus.update_changeset(mstatus, %{status: :approved})
    )
    |> Multi.update(:membership, Membership.approve_changeset(m))
    |> Repo.transaction()
    |> case do
      {:error, _ops, val, _ch} -> {:error, val}
      {:ok, %{membership_status: mstatus}} -> {:ok, mstatus}
    end
  end
end
