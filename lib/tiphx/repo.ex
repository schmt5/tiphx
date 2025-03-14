defmodule Tiphx.Repo do
  use Ecto.Repo,
    otp_app: :tiphx,
    adapter: Ecto.Adapters.Postgres
end
