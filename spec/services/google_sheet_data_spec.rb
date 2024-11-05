require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe GoogleSheetData do
  before(:each) do
    @gsd = GoogleSheetData.new
  end

  it 'successfully creates a Tag' do
    expect(Tag.count).to eq 0
    tag = @gsd.create_tag('Tag1')
    expect(tag.name).to eq 'Tag1'
    expect(Tag.count).to eq 1

    tag = Tag.first
    expect(tag.name).to eq 'Tag1'
  end

  it 'gracefully fails to create a Tag' do
    @gsd.create_tag('Tag1')
    expect(Tag.count).to eq 1
    @gsd.create_tag('Tag1')
    expect(Tag.count).to eq 1
  end

  it 'successfully creates a SwordForm' do
    expect(SwordForm.count).to eq 0
    form_name = 'Form1'
    form_desc = 'Description'
    @gsd.create_form(form_name, form_desc, nil)
    expect(SwordForm.count).to eq 1

    form = SwordForm.first
    expect(form.name).to eq form_name
    expect(form.description).to eq form_desc
    expect(form.tags.count).to eq 0
  end

  it 'successfully creates a SwordForm with Tags' do
    tag1 = create(:tag, name: 'Tag1')
    tag2 = create(:tag, name: 'Tag2')
    tags = [tag1, tag2]

    form_name = 'Form1'
    form_desc = 'Description'
    @gsd.create_form(form_name, form_desc, tags)
    expect(SwordForm.count).to eq 1

    form = SwordForm.first
    expect(form.name).to eq form_name
    expect(form.description).to eq form_desc
    expect(form.tags.count).to eq 2

    # Tags are not guaranteed to be sorted, so will be one of them
    expect(form.tags[0].name).to match(/Tag[1,2]/)
    expect(form.tags[1].name).to match(/Tag[1,2]/)
  end

  it 'gracefully fails to create a SwordForm' do
    @gsd.create_form('Form1', 'Description', nil)
    expect(SwordForm.count).to eq 1
    @gsd.create_form('Form1', 'Description', nil)
    expect(SwordForm.count).to eq 1
  end

  it 'converts a string to Tag objects' do
    # Nil or empty string should return nil
    tag_string = nil
    expect(@gsd.create_or_fetch_tags(tag_string)).to be nil

    tag_string = ''
    expect(@gsd.create_or_fetch_tags(tag_string)).to be nil

    # At this point there should be no Tags in the database
    expect(Tag.count).to eq 0

    # Single entry should return single-item array of Tag objects saved in database
    tag_string = 'Defensive'
    @gsd.create_or_fetch_tags(tag_string)
    expect(@gsd.cached_tags.count).to eq 1
    expect(@gsd.cached_tags[0].name).to match(/Defensive/)
    expect(Tag.count).to eq 1

    # Double entry should return single-item array of Tag objects saved in database
    tag_string = 'Defensive, Form'
    @gsd.create_or_fetch_tags(tag_string)
    expect(@gsd.cached_tags.count).to eq 2
    expect(@gsd.cached_tags[0].name).to match(/Defensive|Form/)
    expect(@gsd.cached_tags[1].name).to match(/Defensive|Form/)
    expect(Tag.count).to eq 2

    # Changing the order should trim properly
    tag_string = 'Form, Defensive, Guard'
    @gsd.create_or_fetch_tags(tag_string)
    expect(@gsd.cached_tags.count).to eq 3
    expect(@gsd.cached_tags[0].name).to match(/Defensive|Form|Guard/)
    expect(@gsd.cached_tags[1].name).to match(/Defensive|Form|Guard/)
    expect(@gsd.cached_tags[2].name).to match(/Defensive|Form|Guard/)
    expect(Tag.count).to eq 3
  end

  it 'correctly fetches Tag from cache when present' do
    # Create a new Tag and prove it is in the cache and the database
    tag = create(:tag, name: 'Tag1')
    @gsd.cache_existing_tags
    expect(Tag.count).to eq 1
    expect(@gsd.cached_tags.count).to eq 1

    # Remove the Tag from the database and prove it's still in the cache
    tag.destroy!
    expect(Tag.count).to eq 0
    expect(@gsd.cached_tags.count).to eq 1

    # Fetch the tag and prove we get it, and it still doesn't exist in the database
    tags = @gsd.create_or_fetch_tags('Tag1')
    expect(Tag.count).to eq 0
    expect(@gsd.cached_tags.count).to eq 1
    expect(tags.count).to eq 1
    expect(tags.first.name).to eq 'Tag1'
  end

  it 'correctly creates a new Tag and caches if not already in cache' do
    create(:tag, name: 'Tag1')
    @gsd.cache_existing_tags
    expect(Tag.count).to eq 1
    expect(@gsd.cached_tags.count).to eq 1

    tags = @gsd.create_or_fetch_tags('Tag2')
    expect(Tag.count).to eq 2
    expect(@gsd.cached_tags.count).to eq 2
    expect(tags.count).to eq 1
    expect(tags.first.name).to eq 'Tag2'

    tags = @gsd.create_or_fetch_tags('Tag1')
    expect(Tag.count).to eq 2
    expect(@gsd.cached_tags.count).to eq 2
    expect(tags.count).to eq 1
    expect(tags.first.name).to eq 'Tag1'
  end

  it 'successfully caches the Tags' do
    create(:tag, name: 'Tag1')
    create(:tag, name: 'Tag2')
    create(:tag, name: 'Tag3')

    @gsd.cache_existing_tags
    expect(@gsd.cached_tags.count).to eq 3
  end

  it 'can find a Tag in the cache' do
    create(:tag, name: 'Tag1')
    @gsd.cache_existing_tags
    expect(@gsd.cached_tags.count).to eq 1

    tag = @gsd.tag_from_cache('Tag1')
    expect(tag.present?).to be true
    expect(tag.name).to eq 'Tag1'
  end

  it 'returns nil if no Tag in cache' do
    tag = @gsd.tag_from_cache('NoTag')
    expect(tag).to be nil
  end
end
# rubocop:enable Metrics/BlockLength
