defmodule PagebuilderWeb.PageEditLive do
  @moduledoc """
  asdasd
  """
  alias PagebuilderWeb.CoreComponents
  use PagebuilderWeb, :live_view
  alias PagebuilderWeb.Components.BlockComponent

  def mount(%{"block_id" => block_id}, _session, socket) do
    page = Pagebuilder.Blocks.get_block!(block_id, with_children?: true)
    page_changeset = Pagebuilder.Blocks.change_block(page)

    {:ok,
     socket
     |> assign(:page, page)
     |> assign(:blocktypes, Pagebuilder.Blocks.list_blocktypes())
     |> assign_form(page_changeset)}
  end

  defp assign_form(socket, block_changeset) do
    if Ecto.Changeset.get_field(block_changeset, :children) == [] do
      empty_block = %Pagebuilder.Block{}
      block_changeset = Ecto.Changeset.put_change(block_changeset, :children, [empty_block])
      assign(socket, :form, to_form(block_changeset))
    else
      assign(socket, :form, to_form(block_changeset))
    end
  end

  def render(assigns) do
    ~H"""
    <h1>Edit:</h1>
    <.simple_form for={@form} phx-submit="save" phx-change="validate">
      <.input field={@form[:content]} />
      <div id="children" phx-hook="SortableInputsFor" class="space-y-2">
        <.inputs_for :let={child} field={@form[:children]}>
          <div class="flex space-x-2 drag-item">
            <.icon name="hero-bars-3" data-handle />
            <input name="block[children_order][]" type="hidden" value={child.index} />
            <.input type="select" field={child[:type]} options={@blocktypes} />
            <.input field={child[:content]} />
            <label>
              <input
                type="checkbox"
                name="block[children_delete][]"
                value={child.index}
                class="hidden"
              />
              <.icon name="hero-x-mark" />
            </label>
          </div>
        </.inputs_for>
        <label class="block cursor-pointer">
          <input type="checkbox" name="block[children_order][]" class="hidden" />
          <.icon name="hero-plus-circle" /> Add Child
        </label>
      </div>
      <:actions>
        <.button phx-disable-with="Saving...">
          Save
        </.button>
      </:actions>
    </.simple_form>
    """
  end

  def handle_event("save", %{"block" => block_params}, socket) do
    %{page: page} = socket.assigns

    case Pagebuilder.Blocks.update_block(page, block_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> push_navigate(to: ~p"/#{page}")
         |> put_flash(:info, "Block updated successfully")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, changeset)}
    end
  end

  def handle_event("validate", %{"block" => block_params}, socket) do
    %{page: page} = socket.assigns

    form =
      page
      |> Pagebuilder.Blocks.change_block(block_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end
end
