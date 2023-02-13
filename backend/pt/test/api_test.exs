Ecto.Adapters.SQL.Sandbox.mode(Pt.Repo, :manual)

defmodule PtTestApi do
  use ExUnit.Case, async: true
  use Plug.Test
  import Pt.Factory

  alias Pt.UsersRouter

  doctest Pt

  @opts UsersRouter.init([])

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pt.Repo)
  end

  @email "test@gmail.com"
  @password "password"

  test "Register user", conn do
    conn =
      conn(:post, "/register", %{email: @email, password: @password})
      |> UsersRouter.call(@opts)

    {status, _headers, _body} = sent_resp(conn)
    assert status == 200
  end

  test "Get user", conn do
    user = insert(:user)

    conn =
      conn(:get, "/get", %{id: user.id})
      |> UsersRouter.call(@opts)

    {status, _headers, body} = sent_resp(conn)
    assert status == 302
    assert Map.get(Jason.decode!(body), "id") == user.id
  end

  test "Get user with invalid id", conn do
    conn =
      conn(:get, "/get", %{id: "never_id"})
      |> UsersRouter.call(@opts)

    {status, _headers, body} = sent_resp(conn)

    assert status == 404
    assert body == "Entity with id: never_id not found"
  end
end
