defmodule Pagebuilder.Repo.Migrations.AddMenuitems do
  use Ecto.Migration

  def change do
    execute(
      "CREATE EXTENSION ltree",
      "DROP EXTENSION ltree"
    )

    create table(:menuitems, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :slug, :string
      add :order, :integer
      add :path, :ltree

      add :parent_id, references(:menuitems, type: :binary_id, on_delete: :nilify_all)
      add :page_id, references(:blocks, type: :binary_id, on_delete: :nilify_all)
      timestamps()
    end

    create index(:menuitems, [:parent_id])
    create index(:menuitems, [:page_id])
    create unique_index(:menuitems, [:slug])
    create index(:menuitems, [:path], using: :gist)
  end
end
