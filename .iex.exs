IEx.configure(inspect: [limit: :infinity])

import Ecto.Query

alias Congregation.{
  Repo,
  Donor,
  Mailer
}

alias Congregation.TaxReceipts.{
  Email,
  Processor
}
