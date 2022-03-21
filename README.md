# RPG Sword Forms

Simple searchable database of sword forms for use in roleplaying games.

Attribution for the favicon: [Delapouite](https://commons.wikimedia.org/wiki/File:61_Glavo_.svg), [CC BY 3.0](https://creativecommons.org/licenses/by/3.0), via Wikimedia Commons.

To run up:

```
bundle install
bundle exec rails s
```

Tests:

`bundle exec rspec`
`bundle exec rubocop`

Configured for a postgres database (see `config/database.yml`).

Seed data:

Seed data can be loaded from a Google Sheet using the [google_drive gem](https://github.com/gimite/google-drive-ruby). Create a Service Account which can access your sheet using [the instructions in the gem](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#service-account) and point the app at it via the environment variables `SWORD_FORM_SERVICE_ACCOUNT` (for the json key) and `SWORD_FORM_SPREADSHEET` (for the spreadsheet key).

Spreadsheet should have the data in the first worksheet, and will skip the first row expecting headings. Columns are expected to be `Name | Description | Tags` with the tags as a comma separated list. Or hack away for your own sheet in `app/services/google_sheet_data.rb` and `db/seeds.rb`.
