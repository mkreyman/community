# Community

## Description

Generate tax receipts for our donors based on QuickBooks reports in CSV format, and print them out as PDF files.

## How to use

Place your template in `templates` directory.
Adjust configuration in `config.exs`.

```elixir
csv = "../../tmp/Sales by Customer Summary with address and email.CSV"  # path relative to lib.
headers = [:name, :amount, :address, :email]  # should be no headers row in the csv file.
TaxReceipts.parse(csv, headers)

Community.TaxReceipts.print()
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
brew install Caskroom/cask/wkhtmltopdf
```
Download `goon` from https://github.com/alco/goon/releases/ and place it into `~/bin`
```elixir
mix deps.get
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

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
