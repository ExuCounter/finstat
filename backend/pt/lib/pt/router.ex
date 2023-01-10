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

      @impl Plug.ErrorHandler
      def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
        send_resp(conn, conn.status, "Something went wrong")
      end
    end
  end
end
