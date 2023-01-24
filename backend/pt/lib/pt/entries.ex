defmodule Pt.Entry do
  import Ecto.Changeset
  alias Pt.{Category, Repo}
  use Pt, :schema
  import Ecto.Query, only: [from: 2]
  alias __MODULE__

  @derive {Jason.Encoder, only: [:id, :amount, :title, :currency, :inserted_at]}

  schema "entries" do
    field(:amount, :integer)
    field(:title, :string)
    field(:currency, :string)
    belongs_to(:category, Category, foreign_key: :category_id, type: Ecto.UUID)

    timestamps()
  end

  @required_fields ~w(title amount category_id currency)a
  @optional_fields ~w(updated_at inserted_at)a

  def create_entry_changeset(struct, payload) do
    struct
    |> cast(payload, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:category_id)
  end

  def get_entries_by_category_id(id) do
    from(e in Entry,
      select: e,
      where: e.category_id == ^id
    )
    |> Repo.all()
  end

  def get_entry_by_id(id) do
    from(e in Entry,
      select: e,
      where: e.id == ^id
    )
    |> Repo.all()
  end

  def delete_entry_by_id(id) do
    with {:ok, entry} <- Repo.get_by_id(Pt.Entry, id) do
      Repo.delete!(entry)
    else
      errors ->
        errors
    end
  end

  def create_entry(entry) do
    Entry.create_entry_changeset(
      %Entry{},
      entry
    )
  end
end
