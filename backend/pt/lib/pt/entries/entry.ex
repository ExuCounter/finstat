defmodule Pt.Entry do
  import Ecto.Changeset
  alias Pt.{Category, Repo, Entry}
  use Pt, :schema
  import Ecto.Query, only: [from: 2]

  @derive {Jason.Encoder, only: [:id, :amount, :title, :currency, :inserted_at]}

  schema "entries" do
    field(:amount, :integer)
    field(:title, :string)
    field(:currency, :string)
    belongs_to(:category, Category, foreign_key: :category_id, type: Ecto.UUID)

    timestamps()
  end

  def create_entry_changeset(struct, payload) do
    struct
    |> cast(payload, [
      :title,
      :amount,
      :category_id,
      :currency,
      :updated_at,
      :inserted_at
    ])
    |> validate_required([:title, :amount, :category_id, :currency])
    |> foreign_key_constraint(:category_id)
  end

  def get_entries_by_category_id(id) do
    from(e in Pt.Entry,
      select: e,
      where: e.category_id == ^id
    )
    |> Repo.all()
  end

  def delete_entry_by_id(id) do
    Repo.get_by_id(Pt.Entry, id)
    |> case do
      {:ok, entry} ->
        Repo.delete!(entry)

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
