defmodule Pt.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do 
      add(:id, :uuid, primary_key: true)
      add :user_id, references(:users, type: :uuid)
      add :title, :string

      timestamps()
    end
  end
end
