# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :congregation,
  ecto_repos: [Congregation.Repo]

# Configures the endpoint
config :congregation, CongregationWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pdFC4H/FS/ZzEbDL6HTz+jwLAZGDMaxXGItjtF6ZjSs4t6BiHlSzCfB7G5Nz7ZKD",
  render_errors: [view: CongregationWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Congregation.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# configuration for the PdfGenerator
# config :pdf_generator,
#   pdf_options: [
#     "--print-media-type",
#     "--page-size",
#     "Letter",
#     "--dpi",
#     "150",
#     "--zoom",
#     "3",
#     "--margin-top",
#     "8",
#     "--margin-right",
#     "8",
#     "--margin-bottom",
#     "8",
#     "--margin-left",
#     "8"
#   ]

config :pdf_generator,
  pdf_options: [
    "--print-media-type",
    "--page-size",
    "A4",
    "--dpi",
    "150",
    "--margin-top",
    "8",
    "--margin-right",
    "8",
    "--margin-bottom",
    "8",
    "--margin-left",
    "8"
  ]

config :congregation,
  tax_receipts_output_dir: "output",
  tax_receipts_templates_dir: "lib/congregation_web/templates/tax_receipts",
  tax_receipts_template: "tax_receipt.eex",
  tax_receipts_logo: "https://bethelrussianchurch.org/wp-content/uploads/2021/01/logo.png",
  thank_you_letter: "Letter from pastors 2020.pdf",
  from_address: System.get_env("SENDGRID_FROM_ADDRESS") || "test@example.com",
  # don't change, as it's hardcoded in PdfGenerator
  tax_receipts_tmp_dir: System.tmp_dir()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
