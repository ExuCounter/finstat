defmodule Pt.UsersRouter do
  use Pt.Router
  alias Pt.{Repo, User}

  get "/get" do
    id = Map.get(conn.query_params, "id")

    User.get_user_by_id(id)
    |> case do
      {:error, %{status: status, message: message}} ->
        send_resp(conn, status, message)

      user ->
        send_resp(
          conn,
          :found,
          Jason.encode!(user)
        )
    end
  end

  post "/register" do
    %{body_params: user} = conn

    result = User.register_user(user)

    case result do
      {:ok, user} ->
        send_resp(
          conn,
          :ok,
          Jason.encode!(user |> Repo.preload(categories: :entries))
        )

      {:error, errors} ->
        send_resp(conn, :bad_request, Jason.encode!(traverse_changeset_errors(errors)))
    end
  end
end
