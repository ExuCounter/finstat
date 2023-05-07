defmodule Pt.User do
  alias Pt.{Repo, Category, Account}
  alias __MODULE__
  import Ecto.Changeset
  use Pt, :schema
  alias Ecto.{Multi}
  import Ecto.Query, only: [from: 2, where: 3]

  @derive {Jason.Encoder, only: [:id, :email, :categories, :inserted_at, :updated_at]}

  schema "users" do
    field(:email, :string)
    field(:password, :string)
    has_many(:categories, Category)
    has_many(:accounts, Account)

    timestamps()
  end

  @required_fields ~w(email password)a

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        change(changeset, Argon2.add_hash(password, hash_key: :password))

      changeset ->
        changeset
    end
  end

  def register_changeset(struct, payload \\ %{}) do
    struct
    |> cast(payload, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> hash_password()
  end

  def sign_in(email, password) do
    user = get_user_by_email(email)

    if user do
      verified = Argon2.verify_pass(password, user.password)

      if verified do
        {:ok, "Successfuly logged in"}
      else
        {:error, "Wrong password"}
      end
    else
      {:error, "No such user registered"}
    end
  end

  def register_user(user) do
    changeset = User.register_changeset(%User{}, user)

    multi_struct =
      Multi.new()
      |> Multi.insert(
        :user,
        changeset
      )
      |> Multi.insert_all(
        :categories,
        Category,
        fn %{user: user} ->
          Enum.map(["Taxi", "Grocery", "Health", "Sport", "Gifts"], fn title ->
            %{
              :title => title,
              :user_id => user.id,
              :inserted_at => NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
              :updated_at => NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
            }
          end)
        end
      )

    result = Repo.transaction(multi_struct)

    case result do
      {:ok, %{user: user, categories: _}} ->
        {:ok, user}

      {:error, changeset} ->
        {:error, changeset}

      {:error, _user, failed_value, _categories} ->
        {:error, failed_value}
    end
  end

  def get_user_by_id(id) do
    Repo.get_by_id(User, id)
    |> case do
      {:ok, user} -> user |> Repo.preload(categories: [:entries], accounts: [])
      errors -> errors
    end
  end

  def filter_by_email(query \\ User, email) do
    query |> where([user], user.email == ^email)
  end

  def get_user_by_email(email) do
    filter_by_email(email) |> Repo.one()
  end
end
