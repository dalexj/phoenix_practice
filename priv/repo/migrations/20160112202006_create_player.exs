defmodule Hello.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :username, :string
      add :color, :string
      add :x, :integer
      add :y, :integer

      timestamps
    end

  end
end
