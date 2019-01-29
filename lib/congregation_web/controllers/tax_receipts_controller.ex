defmodule Congregation.TaxReceiptsController do
  use CongregationWeb, :controller

  # alias Congregation.{Mailer, Donor}
  # alias Congregation.TaxReceipts.Email

  # def send_tax_receipts do
  #   Donor.with_email()
  #   |> Email.tax_receipt_email()
  #   |> Mailer.deliver_later()
  # end

  # def delete(conn, %{"id" => id}) do
  #   donor = Repo.get!(Donor, id)

  #   Repo.delete!(donor)
  #   send_removal_notification()
  #   …
  # end
end
