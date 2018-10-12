defmodule Travenger.Notifications.Entity do
  @moduledoc """
  Entity embedded schema
  """
  use Ecto.Schema

  @derive {Poison.Encoder, only: [:object_type, :object_id, :name]}

  embedded_schema do
    field(:object_type, ObjectTypeEnum)
    field(:object_id, :integer)
    field(:name, :string)
  end
end
