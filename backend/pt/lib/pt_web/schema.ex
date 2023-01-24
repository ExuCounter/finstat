defmodule Pt.Schema do
  use Absinthe.Schema
  alias Pt.{Category, User, Entry, Repo}
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

    @desc "Get user"
    field :user, :user do
      arg(:id, non_null(:id))

      resolve(fn _parent, %{id: id}, _resolution ->
        with user <- User.get_user_by_id(id) do
          {:ok, Repo.preload(user, categories: :entries)}
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
        with {:ok, user} <- User.register_user(user) |> Repo.insert() do
          {:ok, Repo.preload(user, categories: :entries)}
        else
          {:error, _changeset} -> {:error, "Something went wrong"}
        end
      end)
    end
  end
end
