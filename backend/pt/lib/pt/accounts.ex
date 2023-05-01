defmodule Pt.Account do
  alias Pt.{Repo, User}
  alias __MODULE__
  import Ecto.Changeset
  use Pt, :schema
  import Ecto.Query, only: [from: 2]

  @derive {Jason.Encoder, only: [:id, :title, :currency, :balance, :inserted_at, :updated_at]}

  schema "accounts" do
    field(:title, :string)
    field(:currency, :string)
    field(:balance, :integer)
    belongs_to(:user, User, foreign_key: :user_id, type: Ecto.UUID)

    timestamps()
  end

  @required_fields ~w(title currency balance user_id)a

  def create_account_changeset(struct, payload \\ %{}) do
    struct
    |> cast(payload, @required_fields)
    |> validate_required(@required_fields)
  end

  def create_account(account) do
    changeset = create_account_changeset(%Account{}, account)
    changeset |> Repo.insert()
  end

  def get_account_by_id(id) do
    from(e in Account,
      select: e,
      where: e.id == ^id
    )
    |> Repo.all()
  end

  def delete_account_by_id(id) do
    response = Account.get_account_by_id(id)

    case response do
      {:ok, category} -> Repo.delete(category)
      {:error, errors} -> {:error, errors}
    end
  end
end
