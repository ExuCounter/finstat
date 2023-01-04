defmodule Pt.Router do
  defmacro __using__(_opts) do
    quote do
      use Plug.Router

      if Mix.env() == :dev do
        use Plug.Debugger
      end

      use Plug.ErrorHandler

      plug(:match)

      plug(
        Plug.Parsers,
        parsers: [:urlencoded, {:multipart, length: 15_000_000}, :json],
        pass: ["*/*"],
        json_decoder: Jason
      )

      plug(:dispatch)

      def init(opts), do: opts

      def traverse_changeset_errors(changeset) do
        %{
          errors:
            Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
              Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
                opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
              end)
            end)
        }
      end

      # def send_response(conn, :internal_server_error) do
      #   conn |> send_resp(500, "Internal server error")
      # end

      # def send_response(conn, :error, changeset) do
      #   conn
      #   |> send_resp(
      #     400,
      #     Jason.encode!(traverse_changeset_errors(changeset))
      #   )
      # end

      # def send_response(conn, :ok, payload) do
      #   send_resp(conn, 201, payload)
      # end
    end
  end
end
