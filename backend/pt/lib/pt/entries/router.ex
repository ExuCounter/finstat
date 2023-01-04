defmodule Pt.Entry.Router do
  use Pt.Router
  alias Pt.{Repo, Entry}

  plug(:match)
  plug(:dispatch)

  get "/get" do
    user_id = Map.get(conn.query_params, "user_id")

    Entry.get_entries_by_user_id(user_id)
    |> case do
      {:error, status, message} ->
        send_resp(conn, status, message)
      entries ->
        send_resp(conn, :found, Jason.encode!(entries))
    end
  end

  post "/income/create" do
    %{body_params: entry} = conn

    Entry.create_entry_changeset(
      %Entry{},
      entry
    )
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
      _ ->
        send_resp(conn, :internal_server_error, "Internal server error")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
