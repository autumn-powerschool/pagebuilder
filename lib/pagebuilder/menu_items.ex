defmodule Pagebuilder.MenuItems do
  @moduledoc """
  lkajhsdflkajsflk

  """

  alias Pagebuilder.MenuItem
  alias Pagebuilder.Repo

  def list_menu_items() do
    Repo.all(MenuItem)
  end

  def change_menu_item(menu_item \\ %MenuItem{}, attrs \\ %{}) do
    MenuItem.changeset(menu_item, attrs)
  end
end
