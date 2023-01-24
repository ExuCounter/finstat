defmodule Pt.Factory do
  use ExMachina.Ecto, repo: Pt.Repo

  def user_factory do
    %Pt.User{
      email: "example@gmail.com",
      password: "password"
    }
  end

  def category_factory do
    user = build(:user)

    %Pt.Category{
      title: "Dummy category",
      user_id: user.id
    }
  end

  def entry_factory do
    category = build(:category)

    %Pt.Entry{
      title: "Dummy entry",
      amount: 100,
      currency: "USD",
      category_id: category.id
    }
  end
end
