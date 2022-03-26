class GoogleSheetData
  attr_reader :cached_tags

  # On creation, read the Google Sheet
  def initialize(account_key = nil, spreadsheet = nil)
    @cached_tags = []
    return if account_key.nil? || spreadsheet.nil?

    # Get the sheet - see README for expected format
    session = GoogleDrive::Session.from_service_account_key(account_key)
    @data_sheet = session.spreadsheet_by_key(spreadsheet).worksheets.first

    cache_existing_tags
    create_objects
  end

  def create_objects
    # Drop the first line as they are headings
    @data_sheet.rows.drop(1).each do |row|
      tags = create_or_fetch_tags(row[2])
      create_form(row[0], row[1], tags)
    end
  end

  def create_or_fetch_tags(tag_string)
    # Needs to return an array or Tag objects or nil
    return nil if tag_string.blank?

    # tag_string should be a comma separated string, so split and operate
    form_tags = []
    tag_string.split(',').each do |t|
      t.strip!
      # If new, create and add to cache else collect from cache
      form_tags << (tag_from_cache(t).presence || create_tag(t))
    end
    form_tags
  end

  def create_tag(tag_name)
    tag = Tag.new(name: tag_name)
    tag.save! if tag.valid?
    @cached_tags << tag
    tag
  end

  def cache_existing_tags
    @cached_tags = Tag.all.to_a
  end

  def tag_from_cache(tag_name)
    # filter @cached_tags and return correct object - name is unique so should be able to take first
    @cached_tags.select { |t| t.name == tag_name }.first
  end

  def create_form(form_name, form_description, tags)
    form = SwordForm.new(name: form_name, description: form_description)
    form.save! if form.valid?
    form.tags << tags unless tags.nil?
  end
end
