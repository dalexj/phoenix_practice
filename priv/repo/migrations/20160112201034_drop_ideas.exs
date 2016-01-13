defmodule Hello.Repo.Migrations.DropIdeas do
  use Ecto.Migration

  def change do
    drop table(:ideas)
  end
end
