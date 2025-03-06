defmodule PagebuilderWeb.PageLive do
  @moduledoc """
  asdasd
  """
  use PagebuilderWeb, :live_view
  alias PagebuilderWeb.Components.BlockComponent

  @pageid "0e8b841e-6d76-4996-8e58-ab219f3ba56c"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page, Pagebuilder.Blocks.get_block!(@pageid, with_children?: true))}
  end

  def render(assigns) do
    ~H"""
    <BlockComponent.render_block_with_children block={@page} />
    """
  end
end
