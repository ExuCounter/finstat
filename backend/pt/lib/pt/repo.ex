defmodule Pt.Repo do
  use Ecto.Repo,
    otp_app: :pt,
    adapter: Ecto.Adapters.Postgres

  def get_by_id(struct, id) do
    Pt.Repo.get(struct, id)
    |> case do
      nil ->
        {:error, %{message: "Entity with id: #{id} not found", status: :not_found}}

      entity ->
        {:ok, entity}
    end
  end

  defoverridable get: 2, get: 3
  def get(query, id, opts \\ []) do
    super(query, id, opts)
  rescue
    Ecto.Query.CastError -> nil
  end
end
