class GoogleSheetData
  # On creation, read the Google Sheet
  def initialize(account_key = nil, spreadsheet = nil)
    return if account_key.nil? || spreadsheet.nil?

    # Get the sheet - see README for expected format
    session = GoogleDrive::Session.from_service_account_key(account_key)
    @data_sheet = session.spreadsheet_by_key(spreadsheet).worksheets.first

    read_to_csv
  end

  def read_to_csv
    # Drop the first line as they are headings
    @data_sheet.rows.drop(1).each do |row|
      puts row[0]
    end
  end

  def create_objects
  end

  def create_tag(tag_name)
    tag = Tag.new(name: tag_name)
    tag.save! if tag.valid?
  end

  # TODO: tag caching - remember tests!
  def cache_tags
    @tags = Tag.all
  end

  def tag(tag_name)
    # filter @tags and return correct object
  end

  def create_form(form_name, form_description)
    form = SwordForm.new(name: form_name, description: form_description)
    form.save! if form.valid?
  end
end
