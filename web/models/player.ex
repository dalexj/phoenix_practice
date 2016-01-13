defmodule Hello.Player do
  use Hello.Web, :model

  schema "players" do
    field :username, :string
    field :color, :string
    field :x, :integer
    field :y, :integer

    timestamps
  end

  before_insert :set_coords_to_zero

  @required_fields ~w(username color)
  @optional_fields ~w(x y)

  def set_coords_to_zero(changeset) do
    Map.merge(changeset, %{ "x" => 0, "y" => 0 })
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
