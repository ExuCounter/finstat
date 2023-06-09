defmodule Pt.Plug.AuthRouter do
  import Plug.Conn
  alias Pt.{Users}

  def init(opts) do
    opts
  end

  defmodule Unauthorized do
    @moduledoc """
    """

    defexception message: "Unauthorized"
  end

  def call(conn, _opts) do
    # {status, token} =
    #   Enum.find(conn.req_headers, {:error, :not_found}, fn {key, _value} ->
    #     key == "authorization"
    #   end)

    conn

    assign(conn, :hello, :world)

    # if status == :ok do
    #   if token do
    #     conn
    #   end
    # else
    #   conn
    # end
  end
end
