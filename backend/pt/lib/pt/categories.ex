defmodule Pt.Category do
  use Pt, :schema
  import Ecto.Changeset
  alias Pt.{Entry, Repo}
  alias __MODULE__

  @derive {Jason.Encoder, only: [:id, :title, :entries]}

  schema "categories" do
    field(:user_id, Ecto.UUID)
    field(:title, :string)

    has_many(:entries, Entry)

    timestamps()
  end

  @required_fields ~w(title user_id)a
  @optional_fields ~w(entries)a

  def create_category_changeset(struct, payload) do
    struct
    |> cast(payload, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
  end

  def get_category_by_id(id) do
    Repo.get_by_id(Category, id)
  end

  def delete_category_by_id(id) do
    response = Category.get_category_by_id(id)

    case response do
      {:ok, category} -> Repo.delete(category)
      error -> error
    end
  end

  def create_category(category) do
    Category.create_category_changeset(
      %Category{},
      category
    )
  end
end
