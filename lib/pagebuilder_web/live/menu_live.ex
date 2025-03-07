defmodule PagebuilderWeb.MenuLive do
  use PagebuilderWeb, :live_view

  alias Pagebuilder.MenuItems

  # def mount(_params, _session, socket) do
  #   menu_items = MenuItems.list_menu_items()
  #   {:ok, assign(socket, menu_items: menu_items)}
  # end

  def render(assigns) do
    ~H"""
    <h1>MenuLive</h1>
    """
  end
end
