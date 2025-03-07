defmodule Pagebuilder.MenuItem do
  @moduledoc """
  A Menu Item is a tree of references to pages
  """
  use TypedEctoSchema

  import Ecto.Changeset
  alias EctoLtree.LabelTree, as: Ltree

  @type id :: Ecto.UUID.t()
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  typed_schema "menuitems" do
    field :title, :string
    field :slug, :string
    field :order, :integer
    # this will be set automatically by the menuitems_update_path trigger
    # see: `Pagebuilder.Repo.Migrations.AddMenuitems`
    field :path, Ltree

    field :depth, :integer, virtual: true

    timestamps()

    # the relationship between the menu item and content
    belongs_to(:page, Pagebuilder.Block)

    belongs_to(:parent, Pagebuilder.MenuItem)
    has_many(:children, Pagebuilder.MenuItem, foreign_key: :parent_id, on_replace: :delete)
  end

  def changeset(menuitem \\ %__MODULE__{}, attrs, position \\ nil) do
    menuitem
    |> cast(attrs, [:title, :slug, :order, :parent_id, :page_id])
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
end
