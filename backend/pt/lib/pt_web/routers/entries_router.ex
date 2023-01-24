defmodule Pt.EntriesRouter do
  use Pt.Router
  alias Pt.{Repo, Entry}

  get "/get" do
    category_id = Map.get(conn.query_params, "category_id")

    Entry.get_entries_by_category_id(category_id)
    |> case do
      {:error, status, message} ->
        send_resp(conn, status, message)

      entries ->
        send_resp(conn, :found, Jason.encode!(entries))
    end
  end

  post "/create" do
    %{body_params: entry} = conn

    Entry.create_entry(entry)
    |> Repo.insert()
    |> case do
      {:ok, entry} ->
        send_resp(
          conn,
          :ok,
          Jason.encode!(entry)
        )

      {:error, changeset} ->
        send_resp(conn, :bad_request, Jason.encode!(traverse_changeset_errors(changeset)))
    end
  end

  delete "/delete" do
    %{body_params: body_params} = conn

    Entry.delete_entry_by_id(Map.get(body_params, "id"))
    |> case do
      {:error, %{message: message, status: status}} -> send_resp(conn, status, message)
      _ -> send_resp(conn, :ok, "Entry successfuly deleted")
    end
  end

  match _ do
    send_resp(conn, 404, "Specified endpoint for entries not found")
  end
end
