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
    field(:original_id, :string)
    belongs_to(:category, Category, foreign_key: :category_id, type: Ecto.UUID)

    timestamps()
  end

  @required_fields ~w(title amount category_id currency original_id)a
  @optional_fields ~w(updated_at inserted_at)a

  def create_entry_changeset(struct, payload) do
    struct
    |> cast(payload, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:category_id)
    |> unique_constraint(:original_id)
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
    changeset =
      Entry.create_entry_changeset(
        %Entry{},
        entry
      )

    changeset |> Repo.insert()
  end

  def create_entries_from_monobank_api(entries \\ []) do
    previous_entries_ids =
      from(e in "entries", select: e.original_id, where: 1 == 1) |> Repo.all()

    changesets =
      Enum.filter(entries, fn entry -> not Enum.member?(previous_entries_ids, entry["id"]) end)
      |> Enum.map(fn entry ->
        new_entry = %{
          amount: entry["amount"],
          title: entry["description"],
          currency: "#{entry["currencyCode"]}",
          category_id: "974d7328-43c5-4592-b722-9763f3e539f9",
          original_id: entry["id"]
        }

        Entry.create_entry_changeset(%Entry{}, new_entry)
      end)

    Repo.transaction(fn repo ->
      Enum.each(changesets, fn changeset ->
        repo.insert!(changeset)
      end)
    end)
  end
end
