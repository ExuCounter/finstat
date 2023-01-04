defmodule Pt.ApiRouter do
  use Pt.Router
  alias Pt.{User, Category, Entry}

  forward("/api/users", to: User.Router)
  forward("/api/categories", to: Category.Router)
  forward("/api/entries", to: Entry.Router)

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
