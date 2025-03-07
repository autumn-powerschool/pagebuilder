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

    execute(
      """
      CREATE OR REPLACE FUNCTION update_menuitem_path() RETURNS TRIGGER AS $$
      DECLARE
        selected_path ltree;
      BEGIN
        IF NEW.parent_id IS NULL THEN
            NEW.path = 'root'::ltree;
        ELSEIF TG_OP = 'INSERT' OR OLD.parent_id IS NULL OR OLD.parent_id != NEW.parent_id THEN
            SELECT path || id::text FROM menuitems WHERE id = NEW.parent_id INTO selected_path;
            IF selected_path IS NULL THEN
                RAISE EXCEPTION 'Invalid parent_id %', NEW.parent_id;
            END IF;
            NEW.path = selected_path;
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
      """,
      """
      DROP FUNCTION update_menuitem_path()
      """
    )

    execute(
      """
      CREATE TRIGGER menuitems_update_path
        BEFORE INSERT OR UPDATE ON menuitems
        FOR EACH ROW EXECUTE PROCEDURE update_menuitem_path();
      """,
      """
      DROP TRIGGER menuitems_update_path ON menuitems
      """
    )
  end
end
