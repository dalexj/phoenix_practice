defmodule Hello.Idea do
  use Hello.Web, :model

  schema "ideas" do
    field :description, :string
    field :score, :integer, default: 0

    timestamps
  end

  @required_fields ~w(description)
  @optional_fields ~w(score)

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
