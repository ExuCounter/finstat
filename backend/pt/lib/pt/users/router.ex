defmodule Pt.User.Router do
  use Pt.Router
  alias Pt.{Repo, Category, User}
  alias Ecto.{Multi}

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

    multi_struct =
      Multi.new()
      |> Multi.insert(
        :user,
        User.register_user(user)
      )
      |> Multi.insert_all(
        :categories,
        Category,
        fn %{user: user} ->
          Enum.map(["Taxi", "Grocery", "Health", "Sport", "Gifts"], fn title ->
            %{
              :title => title,
              :user_id => user.id,
              :inserted_at => NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
              :updated_at => NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
            }
          end)
        end
      )

    result = Repo.transaction(multi_struct)

    case result do
      {:ok, %{user: user, categories: _}} ->
        send_resp(
          conn,
          :ok,
          Jason.encode!(user |> Repo.preload(categories: :entries))
        )

      {:error, _, failed_value, _} ->
        send_resp(conn, :bad_request, Jason.encode!(traverse_changeset_errors(failed_value)))
    end
  end
end
