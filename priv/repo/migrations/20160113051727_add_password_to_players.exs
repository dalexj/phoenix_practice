defmodule Hello.Repo.Migrations.AddPasswordToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :password, :string
    end
  end
end
