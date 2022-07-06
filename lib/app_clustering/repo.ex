defmodule AppClustering.Repo do
  use Ecto.Repo,
    otp_app: :app_clustering,
    adapter: Ecto.Adapters.Postgres
end
