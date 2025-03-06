defmodule PagebuilderWeb.Components.BlockComponent do
  @moduledoc """
  lkjlkj
  """
  use PagebuilderWeb, :html
  # @blocktypes [:page, :richtext, :image, :headline]

  def render_block_with_children(assigns) do
    ~H"""
    <%= render_block_type(assigns) %>
    <div :if={is_list(@block.children)} class="mt-2 ml-2">
      <%= for child <- @block.children do %>
        <%= render_block_with_children(%{block: child}) %>
      <% end %>
    </div>
    """
  end

  def render_block(assigns) do
    ~H"""
    <%= render_block_type(assigns) %>
    """
  end

  defp render_block_type(%{block: %{type: :page}} = assigns) do
    ~H"""
    <div class={[common_block_classes(), "page"]}>
      <%= @block.content %>
    </div>
    """
  end

  defp render_block_type(%{block: %{type: :richtext} = _block} = assigns) do
    ~H"""
    <div class={common_block_classes()}>
      <%= raw(@block.content) %>
    </div>
    """
  end

  defp render_block_type(%{block: %{type: :headline} = _block} = assigns) do
    ~H"""
    <h1 class={common_block_classes()}><%= @block.content %></h1>
    """
  end

  defp render_block_type(%{block: %{type: :image} = _block} = assigns) do
    ~H"""
    <img class={common_block_classes()} src="https://placecage.lucidinternets.com/300/400" />
    """
  end

  defp common_block_classes, do: "mt-1"
end
