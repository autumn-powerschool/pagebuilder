defmodule Pagebuilder.Block do
  @moduledoc """
  A block is a piece of content that can be rendered
  """
  use TypedEctoSchema
  import Ecto.Changeset

  @blocktypes [:page, :richtext, :image, :headline]

  @type id :: Ecto.UUID.t()
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  typed_schema "blocks" do
    field :type, Ecto.Enum, values: @blocktypes
    # this is not the final form of how to put content into a block
    # it's probably a map with a bunch of type-specific data. I just wanted _something_
    field :content, :string
    field :order, :integer
    timestamps()
    belongs_to(:parent, Pagebuilder.Block)
    has_many(:children, Pagebuilder.Block, foreign_key: :parent_id, on_replace: :delete)
  end

  def changeset(block \\ %__MODULE__{}, attrs, position \\ nil) do
    block
    |> cast(attrs, [:type, :content, :parent_id, :order])
    |> validate_required([:type, :content])
    |> validate_inclusion(:type, @blocktypes)
    |> maybe_set_order(position)
    |> cast_assoc(:children,
      with: &changeset/3,
      sort_param: :children_order,
      drop_param: :children_delete
    )
  end

  # position will only come when we're dealing with the
  # cast_assoc call in the changeset function above
  # and is driven by the sort_param: :children_order
  def maybe_set_order(changeset, nil), do: changeset

  def maybe_set_order(changeset, position) do
    change(changeset, order: position)
  end

  def blocktypes, do: @blocktypes
end
