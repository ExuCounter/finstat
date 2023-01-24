defmodule Pt.User do
  alias Pt.{Repo, Category}
  alias __MODULE__
  import Ecto.Changeset
  use Pt, :schema

  @derive {Jason.Encoder, only: [:id, :email, :categories, :inserted_at, :updated_at]}

  schema "users" do
    field(:email, :string)
    field(:password, :string)
    has_many(:categories, Category)

    timestamps()
  end

  @required_fields ~w(email password)a
  @optional_fields ~w(inserted_at updated_at)a

  def register_changeset(struct, payload) do
    struct
    |> cast(payload, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def register_user(user) do
    Pt.User.register_changeset(%User{}, user)
  end

  def get_user_by_id(id) do
    Repo.get_by_id(User, id)
    |> case do
      {:ok, user} -> user |> Repo.preload(categories: :entries)
      errors -> errors
    end
  end
end
