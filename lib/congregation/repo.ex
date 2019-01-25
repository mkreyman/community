defmodule Congregation.Repo do
  use Ecto.Repo,
    otp_app: :congregation,
    adapter: Ecto.Adapters.Postgres
end
