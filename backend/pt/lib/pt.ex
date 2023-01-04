defmodule Pt do
  def schema do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end

  # forward("/api", to: Pt.ApiRouter)

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
