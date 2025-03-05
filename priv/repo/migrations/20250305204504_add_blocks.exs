defmodule Pagebuilder.Repo.Migrations.AddBlocks do
  use Ecto.Migration

  def change do
    create table(:blocks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :content, :string
      add :order, :integer
      add :parent_id, references(:blocks, type: :binary_id)

      timestamps()
    end

    # create index(:blocks, [:children])
    create index(:blocks, [:parent_id])
  end
end
