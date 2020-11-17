defmodule Meetings.Application do
  use Application

  def start(_, _) do
    children = [Meetings.Repo]
    opts = [strategy: :one_for_one, name: Meetings.ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end
