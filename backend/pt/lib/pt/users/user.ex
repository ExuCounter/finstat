defmodule Pt.User do
  alias Pt.{Repo, Category}
  import Ecto.Changeset
  use Pt, :schema

  @derive {Jason.Encoder, only: [:id, :email, :categories, :inserted_at, :updated_at]}

  schema "users" do
    field(:email, :string)
    field(:password, :string)
    has_many(:categories, Category)

    timestamps()
  end

  def register_changeset(struct, payload) do
    struct
    |> cast(payload, [:email, :password, :inserted_at, :updated_at])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def register_user(user) do
    Pt.User.register_changeset(%Pt.User{}, user)
  end

  def get_user_by_id(id) do
    Repo.get_by_id(Pt.User, id)
    |> case do
      {:ok, user} -> user |> Repo.preload(categories: :entries)
      errors -> errors
    end
  end
end
