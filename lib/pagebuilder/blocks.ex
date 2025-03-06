defmodule Pagebuilder.Blocks do
  @moduledoc """
  Block context
  """

  import Ecto.Query

  alias Pagebuilder.Block
  alias Pagebuilder.Repo

  def get_block!(id, opts \\ []) do
    from(b in Block,
      where: b.id == ^id,
      order_by: [b.order, b.inserted_at]
    )
    |> with_parent(Keyword.get(opts, :with_parent?, false))
    |> with_children(Keyword.get(opts, :with_children?, false))
    |> Repo.one!()
  end

  defp with_parent(query, false), do: query

  defp with_parent(query, true) do
    query
    |> preload(:parent)
  end

  defp with_children(query, false), do: query

  defp with_children(query, true) do
    children_order_query = from(c in Block, order_by: [c.order, c.inserted_at])
    # posts_query = from p in Post, where: p.state == :published
    # Repo.all from a in Author, preload: [posts: ^{posts_query, [:comments]}]
    query
    |> preload(children: ^{children_order_query, [:children]})
  end

  def change_block(block, params \\ %{}) do
    Block.changeset(block, params)
  end

  def update_block(block, params) do
    block
    |> Block.changeset(params)
    |> Repo.update()
  end

  def list_blocktypes, do: Block.blocktypes()
end
