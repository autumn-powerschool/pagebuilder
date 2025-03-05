defmodule Pagebuilder.Repo do
  use Ecto.Repo,
    otp_app: :pagebuilder,
    adapter: Ecto.Adapters.Postgres
end
