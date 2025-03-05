defmodule Pagebuilder.Block do
  @moduledoc """
  A block is a piece of content that can be rendered
  """
  use TypedEctoSchema
  import Ecto.Changeset

  @blocktypes [:richtext, :image, :headline]

  @type id :: Ecto.UUID.t()
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  typed_schema "blocks" do
    field :type, Ecto.Enum, values: @blocktypes
    field :content, :string
    field :order, :integer
    timestamps()
    belongs_to(:parent, Pagebuilder.Block)
    has_many(:children, Pagebuilder.Block, foreign_key: :parent_id)
  end

  def changeset(block \\ %__MODULE__{}, attrs) do
    block
    |> cast(attrs, [:type, :content, :parent_id, :order])
    |> validate_required([:type, :content])
    |> validate_inclusion(:type, @blocktypes)
  end
end
