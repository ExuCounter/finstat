defmodule Pt.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table("entries", primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add :amount, :integer
      add :currency, :string
      add :title, :string
      add :category_id, references(:categories, type: :uuid)

      timestamps()
    end
  end
end
