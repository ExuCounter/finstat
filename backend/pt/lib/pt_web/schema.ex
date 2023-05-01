defmodule Pt.Schema do
  use Absinthe.Schema
  alias Pt.{Category, User, Entry, Repo, Account}
  import_types(Pt.Schema.Notation)

  query do
    @desc "Get category"
    field :category, :category do
      arg(:id, non_null(:id))

      resolve(fn _parent, %{id: id}, _resolution ->
        with {:ok, category} <- Category.get_category_by_id(id) do
          {:ok, Repo.preload(category, [:entries])}
        end
      end)
    end

    field :account, :account do
      arg(:id, non_null(:id))

      resolve(fn _parent, %{id: id}, _resolution ->
        with {:ok, account} <- Account.get_account_by_id(id) do
          {:ok, account}
        end
      end)
    end

    field :create_account, :account do
      arg(:user_id, non_null(:id))
      arg(:title, non_null(:string))
      arg(:balance, non_null(:integer))
      arg(:currency, non_null(:string))

      resolve(fn _parent,
                 %{user_id: user_id, title: title, balance: balance, currency: currency},
                 _resolution ->
        with {:ok, account} <-
               Account.create_account(%{
                 title: title,
                 balance: balance,
                 user_id: user_id,
                 currency: currency
               })
               |> IO.inspect() do
          {:ok, account}
        else
          {:error, _} ->
            {:error, "Account is not created"}
        end
      end)
    end

    @desc "Get user"
    field :user, :user do
      arg(:id, non_null(:id))

      resolve(fn _parent, %{id: id}, _resolution ->
        with user <- User.get_user_by_id(id) do
          {:ok, user}
        end
      end)
    end

    @desc "Get entries"
    field :entries, list_of(:entry) do
      arg(:category_id, non_null(:id))
      resolve(fn _parent, %{id: id}, _resolution -> Entry.get_entries_by_category_id(id) end)
    end

    @desc "Get entry"
    field :entry, :entry do
      arg(:id, non_null(:id))
      resolve(fn _parent, %{id: id}, _resolution -> Entry.get_entry_by_id(id) end)
    end

    @desc "Register a user"
    field :register_user, :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(fn _parent, user, _resolution ->
        with {:ok, user} <- User.register_user(user) do
          {:ok, Repo.preload(user, categories: :entries)}
        else
          {:error, _} ->
            {:error, "User is not registered"}
        end
      end)
    end
  end
end
