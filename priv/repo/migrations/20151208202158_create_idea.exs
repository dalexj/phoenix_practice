defmodule Hello.Repo.Migrations.CreateIdea do
  use Ecto.Migration

  def change do
    create table(:ideas) do
      add :description, :string
      add :score, :integer

      timestamps
    end

  end
end
