defmodule Pt.Schema.Notation do
  use Absinthe.Schema.Notation

  object :entry do
    field(:id, :id)
    field(:amount, :integer)
    field(:title, :string)
    field(:currency, :string)
  end

  object :user do
    field(:id, :id)
    field(:email, :string)
    field(:password, :string)
    field(:categories, list_of(:category))
    field(:accounts, list_of(:account))
  end

  object :category do
    field(:id, :id)
    field(:title, :string)
    field(:entries, list_of(:entry))
  end

  object :account do
    field(:id, :id)
    field(:title, :string)
    field(:balance, :string)
    field(:currency, :string)
  end
end
