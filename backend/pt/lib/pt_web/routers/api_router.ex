defmodule Pt.ApiRouter do
  use Pt.Router
  alias Pt.{UsersRouter, CategoriesRouter, EntriesRouter}

  forward("/api/users", to: UsersRouter)
  forward("/api/categories", to: CategoriesRouter)
  forward("/api/entries", to: EntriesRouter)

  forward("/api/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [schema: Pt.Schema]
  )

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
