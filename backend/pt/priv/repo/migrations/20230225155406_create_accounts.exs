defmodule Pt.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table("accounts", primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add :title, :string
      add :currency, :string
      add :user_id, references(:users, type: :uuid)
      add :balance, :integer

      timestamps()
    end
  end
end
