defmodule Pt.Repo.Migrations.AddCreatedAtToEntriesTable do
  use Ecto.Migration

  def change do
    alter table("entries") do
      add(:original_id, :string)
    end

    create(unique_index(:entries, [:original_id]))
  end
end
