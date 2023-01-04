defmodule Pt.User do
  alias Pt.{Repo, Category}
  import Pt.Helpers, only: [is_uuid: 1]
  import Ecto.Query, only: [from: 2]
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

  def get_user_by_id(id) when is_uuid(id) do
    from(u in Pt.User,
      select: u,
      where: u.id == ^id,
      preload: [categories: :entries]
    )
    |> Repo.all()
  end

  def get_user_by_id(id) do
    {:error, :not_found, "User with id:#{id} not found"}
  end
end
