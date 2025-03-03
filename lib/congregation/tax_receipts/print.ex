defmodule Congregation.TaxReceipts.Processor do
  require Logger

  alias Congregation.Donor

  @output_dir Application.get_env(:congregation, :tax_receipts_output_dir)
  @templates_dir Application.get_env(:congregation, :tax_receipts_templates_dir)
  @template Application.get_env(:congregation, :tax_receipts_template)

  def parse(csv, headers) do
    csv
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: headers, strip_fields: true)
    |> Enum.map(fn {status, record} ->
      case status do
        :ok ->
          record_with_trimmed_name =
            record
            |> Map.update!(:name, &String.trim/1)

          Donor.create_or_update(record_with_trimmed_name)

        _ ->
          {:error, record}
      end
    end)
  end

  def print(with_filter \\ nil)

  def print(donor_name) when is_binary(donor_name) do
    with donor when not is_nil(donor) <- Donor.get_by(donor_name) do
      donor
      |> IO.inspect()
      |> to_pdf()
    end
  end

  def print(with_filter) do
    Donor.filtered(with_filter)
    |> Task.async_stream(&to_pdf/1,
      max_concurrency: System.schedulers_online() * 2,
      timeout: 30_000
    )
    |> Enum.to_list()
  end

  defp to_pdf(donor) do
    html = eval_template(donor)
    filename = donor.name
    renamed = Path.join(@output_dir, "/#{filename}.pdf")

    with {:ok, file} <-
           PdfGenerator.generate(
             html,
             delete_temporary: true,
             filename: filename,
             page_size: "letter"
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
end
