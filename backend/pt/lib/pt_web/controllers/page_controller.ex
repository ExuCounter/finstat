defmodule PtWeb.PageController do
  use PtWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
