defmodule Congregation.TaxReceipts.Email do
  import Bamboo.Email
  alias Congregation.{Mailer, Donor}

  @from_address Application.get_env(:congregation, :from_address)
  @attachment_dir Application.get_env(:congregation, :tax_receipts_output_dir)
  # @thank_you_letter Path.join(
  #                     @attachment_dir,
  #                     Application.get_env(:congregation, :thank_you_letter)
  #                   )

  def send(with_filter \\ :with_email_only) do
    Donor.filtered(with_filter)
    |> Enum.map(fn donor ->
      to_email(donor)
      :timer.sleep(Enum.random(1000..15000))
    end)
  end

  defp to_email(donor) do
    try do
      tax_receipt_email(donor)
      |> Mailer.deliver_later()
    catch
      {:closed, _} -> Donor.reset_status(donor)
      :timeout -> Donor.reset_status(donor)
    else
      _ -> toggle_receipt_emailed(donor)
    end
  end

  defp tax_receipt_email(donor) do
    receipt = Path.join(@attachment_dir, "/#{donor.name}.pdf")

    text_body = "\nPlease see attached.\n\nThank you!\nBethel Community"

    html_body = "<p>Please see attached.</p>\n<p>Thank you!\n<br>Bethel Community</p>\n"

    new_email(
      from: @from_address,
      to: donor.email,
      subject: "Your donation receipt from Bethel Community",
      text_body: text_body,
      html_body: html_body
    )
    |> put_attachment(receipt)

    # |> put_attachment(@thank_you_letter)
  end

  defp toggle_receipt_emailed(donor) do
    Donor.update(%{name: donor.name, receipt_emailed: true})
  end
end
