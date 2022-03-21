require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe GoogleSheetData do
  before(:each) do
    @gsd = GoogleSheetData.new
  end

  it 'successfully creates a Tag' do
    expect(Tag.all.count).to eq 0
    @gsd.create_tag('Tag1')
    expect(Tag.all.count).to eq 1

    tag = Tag.all.first
    expect(tag.name).to eq 'Tag1'
  end

  it 'gracefully fails to create a Tag' do
    @gsd.create_tag('Tag1')
    expect(Tag.all.count).to eq 1
    @gsd.create_tag('Tag1')
    expect(Tag.all.count).to eq 1
  end

  it 'successfully creates a SwordForm' do
    expect(SwordForm.all.count).to eq 0
    form_name = 'Form1'
    form_desc = 'Description'
    @gsd.create_form(form_name, form_desc)
    expect(SwordForm.all.count).to eq 1

    form = SwordForm.all.first
    expect(form.name).to eq form_name
    expect(form.description).to eq form_desc
  end

  it 'gracefully fails to create a SwordForm' do
    @gsd.create_form('Form1', 'Description')
    expect(SwordForm.all.count).to eq 1
    @gsd.create_form('Form1', 'Description')
    expect(SwordForm.all.count).to eq 1
  end

  it 'successfully creates a Tagged Form'
  it 'successfully caches the Tags'
  it 'can find a Tag in the cache'
end
# rubocop:enable Metrics/BlockLength
