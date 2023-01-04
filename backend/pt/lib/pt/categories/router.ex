defmodule Pt.Category.Router do
  use Pt.Router
  alias Pt.{Category, Repo}

  post "/income/create" do
    %{body_params: category} = conn

    category = Category.create_category(category)
    IO.inspect(category.valid?)

    if category.valid? do
      Repo.insert(category)
      |> case do
        {:ok, category} ->
          send_resp(
            conn,
            :ok,
            Jason.encode!(
              category
              |> Repo.preload([:entries])
            )
          )
        {:error, changeset} ->
          send_resp(
            conn,
            :ok,
            Jason.encode!(traverse_changeset_errors(changeset))
          )
      end
    else
      send_resp(conn, :bad_request, Jason.encode!(traverse_changeset_errors(category)))
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
