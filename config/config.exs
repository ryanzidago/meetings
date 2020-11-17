import Config

config :meetings, ecto_repos: [Meetings.Repo]

config :meetings, Meetings.Repo,
  database: "meetings_#{Mix.env()}",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

import_config "#{config_env()}.exs"
