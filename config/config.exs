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
  secret_key_base: System.get_env("TAX_RECEIPTS_SECRET"),,
  render_errors: [view: CongregationWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Congregation.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :congregation,
  tax_receipts_output_dir: "output",
  tax_receipts_templates_dir: "lib/congregation_web/templates/tax_receipts",
  tax_receipts_template: "tax_receipt.eex",
  tax_receipts_logo: System.get_env("TAX_RECEIPTS_LOGO_URL"),
  thank_you_letter: "Letter from pastors 2020.pdf",
  from_address: System.get_env("SENDGRID_FROM_ADDRESS") || "test@example.com",
  # don't change, as it's hardcoded in PdfGenerator
  tax_receipts_tmp_dir: System.tmp_dir()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
