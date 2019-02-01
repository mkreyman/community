# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :community,
  ecto_repos: [Community.Repo]

# Configures the endpoint
config :community, CommunityWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pdFC4H/FS/ZzEbDL6HTz+jwLAZGDMaxXGItjtF6ZjSs4t6BiHlSzCfB7G5Nz7ZKD",
  render_errors: [view: CommunitynWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Community.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# configuration for the PdfGenerator
config :pdf_generator,
  pdf_options: [
    "--print-media-type",
    "--page-size",
    "Letter",
    "--dpi",
    "150",
    "--zoom",
    "3",
    "--margin-top",
    "8",
    "--margin-right",
    "8",
    "--margin-bottom",
    "8",
    "--margin-left",
    "8"
  ]

config :community,
  tax_receipts_output_dir: "output",
  tax_receipts_templates_dir: "lib/community_web/templates/tax_receipts",
  tax_receipts_template: "tax_receipt.eex",
  tax_receipts_logo: "logo.png",
  thank_you_letter: "Letter from pastors 2018.pdf",
  from_address: System.get_env("SENDGRID_FROM_ADDRESS") || "test@example.com",
  # don't change, as it's hardcoded in PdfGenerator
  tax_receipts_tmp_dir: System.tmp_dir()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
