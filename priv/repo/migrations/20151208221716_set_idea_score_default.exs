defmodule Hello.Repo.Migrations.SetIdeaScoreDefault do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      modify :score, :integer, default: 0
    end
  end
end
