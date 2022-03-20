class GoogleSheetData
  # On creation, read the Google Sheet
  def initialize(account_key = nil, spreadsheet = nil)
    return if account_key.nil? || spreadsheet.nil?

    # Get the sheet
    session = GoogleDrive::Session.from_service_account_key(account_key)
    sheet = session.spreadsheet_by_key(spreadsheet)
    # monthly = read_data(sheet.worksheets.first, 'monthly')
  end

  def read_to_csv
  end

  def create_objects
  end

  def create_tag(tag_name)
    tag = Tag.new(name: tag_name)
    tag.save! if tag.valid?
  end

  def create_form(form_name, form_description)
    form = SwordForm.new(name: form_name, description: form_description)
    form.save! if form.valid?
  end
end

# connects
# reads spreadsheet to CSV
# for each CSV line
# - creating object
# - for each object, save if valid

# Creates Tags
# Creates Forms and connects Tags
