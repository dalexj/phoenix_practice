defmodule Hello.IdeaTest do
  use Hello.ModelCase

  alias Hello.Idea

  @valid_attrs %{description: "some content", score: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Idea.changeset(%Idea{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Idea.changeset(%Idea{}, @invalid_attrs)
    refute changeset.valid?
  end
end
