defmodule Pt.Entry do
  import Ecto.Changeset
  alias Pt.{Category, Repo}
  use Pt, :schema
  import Pt.Helpers, only: [is_uuid: 1]
  import Ecto.Query, only: [from: 2]

  @derive {Jason.Encoder, only: [:id, :amount, :title, :inserted_at]}

  schema "entries" do
    field(:amount, :integer)
    field(:title, :string)
    belongs_to(:category, Category, foreign_key: :category_id, type: Ecto.UUID)

    timestamps()
  end

  def create_entry_changeset(struct, payload) do
    struct
    |> cast(payload, [:title, :amount, :category_id, :inserted_at, :updated_at])
    |> validate_required([:title, :amount, :category_id])
  end

  def get_entries_by_user_id(user_id) when is_uuid(user_id) do
      from(e in Pt.Entry,
        select: e,
        where: e.user_id == ^user_id
      )
      |> Repo.all()
  end

  def get_entries_by_user_id(user_id) do
    {:error, :not_found, "Entries for id:#{user_id} not found"}
  end
end
