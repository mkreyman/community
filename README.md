# Congregation

## Description

Generate tax receipts for our donors based on QuickBooks reports in CSV format, and print them out as PDF files.

## How to use

Place your template in `lib/congregation_web/templates/tax_receipts/` directory.
Adjust configuration in `config/config.exs`.

```elixir
iex -S mix
# path relative to lib/congregation/tax_receipts/print.ex
csv = "../../../tmp/Donations-by-Member-2020.csv"

# should be no headers row in the csv file.
headers = [:name, :amount, :address, :email]
Processor.parse(csv, headers)

Processor.print(:current) // where amount is not nil

## More examples

Processor.print(:with_address_and_email)
Processor.print(:current) // amount > 0
Email.send(:with_email_only)

Donor.filtered(:zero) |> Enum.count
Donor.filtered(:current) |> Enum.count
Donor |> Repo.all |> Enum.count
Donor.filtered(:with_email) |> Enum.count

Donor.update_status() ?

headers = [:email, :name, :address]
csv = "../../../tmp/subs_cleaned_for_import.csv"
Processor.parse(csv, headers)

headers = [:name, :email, :phone, :address]
csv = "../../../tmp/export-20190130-030325-for-import.csv"
Processor.parse(csv, headers)


Donor.summary("smith")
Donor.update(%{name: "John Smith", email: "jsmith@gmail.com", receipt_emailed: nil})

Donor.filtered(:with_email)
Processor.print(:with_email)
Email.send(:with_email)

Donor.create_or_update(%{amount: 100, email: "jane.smith@gmail.com", name: "Jane Smith"})
donor = Repo.get(Donor, 104)
Repo.delete(donor)

psql -U mkreyman -d congregation_dev -c "Cy (Select * From donors LIMIT 2000) To STDOUT With CSV HEADER DELIMITER ',';" > ~/donors_data.csv

# Updating donor's name
donor = Repo.get(Donor, 400)
params = %{name: "John W Smith", email: "john.w.smith@aol.com"}
donor |> Donor.changeset(params) |> Repo.update()

# testing
UPDATE donors SET receipt_emailed = true;
UPDATE donors SET receipt_emailed = null;

SELECT * FROM donors WHERE email IS NOT null;
SELECT * FROM donors WHERE receipt_emailed IS true;

params = %{email: "mark@congregation.org", receipt_emailed: nil}
donor |> Donor.changeset(params) |> Repo.update()
Processor.print(:with_email)
Email.send(:with_email)

# revert back
params = %{email: "john@aol.com", receipt_emailed: nil}
donor |> Donor.changeset(params) |> Repo.update()
Processor.print(:with_email)
Email.send(:with_email)
```

Generated pdf files should appear in `output` directory.

## Notes

We use two reports from QuickBooks:

- Sales by Customer Summary (:name, :amount)
- Customer Contact List (:name, :address)

PDF generator library:
https://github.com/gutschilla/elixir-pdf-generator

Install dependancies:

```
brew install wkhtmltopdf
brew install postgres
pg_ctl -D /usr/local/var/postgres start
```

Download `goon` from https://github.com/alco/goon/releases/ and place it into `~/bin`

```elixir
mix deps.get
mix ecto.drop
mix ecto.create
mix ecto.migrate
iex -S mix
```

An example of using EEx templates:
https://codewords.recurse.com/issues/five/building-a-web-framework-from-scratch-in-elixir

```elixir
html = "<html><body><p>Hi there!</p></body></html>"
pdf_options = Application.fetch_env!(:pdf_generator, :pdf_options)
{ :ok, filename }    = PdfGenerator.generate html, shell_params: pdf_options
```

Using inline images in html:
https://elixirforum.com/t/pdf-generation-with-pdfgenerator/9963

<!-- To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html). -->

## Learn more

- Official website: http://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
