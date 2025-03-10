defmodule Pagebuilder.MenuItems do
  @moduledoc """
  lkajhsdflkajsflk

  """
  import Ecto.Query
  alias Pagebuilder.MenuItem
  alias Pagebuilder.Repo

  def list_menu_items do
    Repo.all(MenuItem)
  end

  def change_menu_item(menu_item \\ %MenuItem{}, attrs \\ %{}) do
    MenuItem.changeset(menu_item, attrs)
  end

  def all_descendants_of(menu_item_id) do
    to_look = "*.#{menu_item_id}.*"

    from(mi in MenuItem,
      where: fragment("?::ltree ~ ?::lquery", mi.path, ^to_look)
    )
    |> Repo.all()
  end
end
