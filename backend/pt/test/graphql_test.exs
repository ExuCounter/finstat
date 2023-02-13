Ecto.Adapters.SQL.Sandbox.mode(Pt.Repo, :manual)

defmodule GraphqlTest do
  use ExUnit.Case, async: true
  import Pt.Factory
  alias Pt.{Repo, Category, Entry, User}
  doctest Pt

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pt.Repo)
  end

  test "Register user" do
    user = insert(:user)
    assert user.email == "example@gmail.com"
  end

  test "Get user by id" do
    user = insert(:user)
    assert user = User.get_user_by_id(user.id)
  end

  test "Create entry" do
    entry = insert(:entry)
    assert entry.title == "Dummy entry"
  end

  test "Delete entry by id" do
    entry = insert(:entry)
    {status, _} = Repo.delete(entry)
    assert :ok == status
  end

  test "Create category" do
    category = insert(:category)
    assert category.title == "Dummy category"
  end

  test "Get category by id" do
    category = insert(:category)
    {_, asserted_category} = Category.get_category_by_id(category.id)
    assert category === asserted_category
  end

  test "Delete category by id" do
    category = insert(:category)
    {status, _} = Repo.delete(category)
    assert :ok == status
  end

  test "Get entries by category id" do
    category = insert(:category) |> Repo.preload(:entries)
    entries = Entry.get_entries_by_category_id(category.id)
    assert category.entries == entries
  end
end
