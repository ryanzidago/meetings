defmodule Meetings.Repo do
  use Ecto.Repo,
    otp_app: :meetings,
    adapter: Ecto.Adapters.Postgres
end
