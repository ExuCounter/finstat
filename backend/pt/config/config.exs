import Config

config :pt, Pt.Repo,
  database: System.get_env("DB_NAME"),
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :pt, Pt.Guardian,
  issuer: "pt",
  secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"

config :pt, ecto_repos: [Pt.Repo]
