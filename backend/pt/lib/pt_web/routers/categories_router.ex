defmodule Pt.CategoriesRouter do
  use Pt.Router
  alias Pt.{Category, Repo}

  post "/create" do
    %{body_params: category} = conn

    Category.create_category(category)
    |> Repo.insert()
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
  end

  delete "/delete" do
    %{body_params: body_params} = conn

    Category.delete_category_by_id(Map.get(body_params, "id"))
    |> case do
      {:error, %{message: message, status: status}} -> send_resp(conn, status, message)
      _ -> send_resp(conn, :ok, "Category successfuly deleted")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
