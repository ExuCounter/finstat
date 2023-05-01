defmodule Pt.Category do
  use Pt, :schema
  import Ecto.Changeset
  alias Pt.{Entry, Repo, User}
  alias __MODULE__

  @derive {Jason.Encoder, only: [:id, :title, :entries]}

  schema "categories" do
    belongs_to(:user, User, foreign_key: :user_id, type: Ecto.UUID)
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
      {:error, errors} -> {:error, errors}
    end
  end

  def create_category(category) do
    changeset =
      Category.create_category_changeset(
        %Category{},
        category
      )

    changeset
    |> Repo.insert()
  end
end
