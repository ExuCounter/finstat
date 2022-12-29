defmodule Pt.Repo do
  use Ecto.Repo,
    otp_app: :pt,
    adapter: Ecto.Adapters.Postgres
end
