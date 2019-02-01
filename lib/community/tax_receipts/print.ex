defmodule Community.TaxReceipts.Processor do
  require Logger

  alias Community.Contributions.Donor

  @output_dir Application.get_env(:community, :tax_receipts_output_dir)
  @templates_dir Application.get_env(:community, :tax_receipts_templates_dir)
  @template Application.get_env(:community, :tax_receipts_template)
  @logo Application.get_env(:community, :tax_receipts_logo)
  @tmp_dir Application.get_env(:community, :tax_receipts_tmp_dir)
  @pdf_options Application.fetch_env!(:pdf_generator, :pdf_options)

  # The Sales by Customer Summary report: "../tmp/Sales by Customer Summary 2017.CSV"
  # The Customer Contact List report: "../tmp/Customer Contact List from QuickBooks.CSV"
  def parse(csv, headers) do
    csv
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: headers, strip_fields: true)
    |> Enum.map(fn {status, record} ->
      case status do
        :ok -> Donor.create_or_update(record)
        _ -> {:error, record}
      end
    end)
  end

  def print(with_filter \\ nil) do
    copy_logo_to_tmp_dir()

    Donor.filtered(with_filter)
    |> Enum.map(&to_pdf(&1))
  end

  defp to_pdf(donor) do
    html = eval_template(donor)
    filename = donor.name
    renamed = Path.join(@output_dir, "/#{filename}.pdf")

    with {:ok, file} <-
           PdfGenerator.generate(
             html,
             shell_params: @pdf_options,
             delete_temporary: true,
             filename: filename
           ) do
      File.rename(file, renamed)
      {:ok, renamed}
    else
      {:error, error} ->
        Logger.error(fn ->
          "Something went wrong: #{inspect(donor)} - #{inspect(error)}"
        end)
    end
  end

  defp eval_template(donor) do
    EEx.eval_file("#{@templates_dir}/#{@template}", donor: donor)
  end

  defp copy_logo_to_tmp_dir do
    File.cp("#{@templates_dir}/#{@logo}", "#{@tmp_dir}/#{@logo}")
  end
end
