defmodule Pt.Category do
  use Pt, :schema
  import Ecto.Changeset
  alias Pt.{Category, Entry}

  @derive {Jason.Encoder, only: [:id, :title, :entries]}

  schema "categories" do
    field(:user_id, Ecto.UUID)
    field(:title, :string)

    has_many(:entries, Entry)

    timestamps()
  end

  def create_category_changeset(struct, payload) do
    struct
    |> cast(payload, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end

  def create_category(category) do
    Category.create_category_changeset(
      %Category{},
      category
    )
  end
end
