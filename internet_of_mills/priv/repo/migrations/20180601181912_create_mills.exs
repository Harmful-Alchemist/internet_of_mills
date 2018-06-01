defmodule InternetOfMills.Repo.Migrations.CreateMills do
  use Ecto.Migration

  def change do
    create table(:mills) do
      add :name, :string
      add :type, :string
      add :io_pin, :integer

      timestamps()
    end

  end
end
