require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Accessing the sword forms pages' do
  scenario 'seeing the list of forms on the index page' do
    form1 = create(:sword_form, name: 'Form 1')
    form2 = create(:sword_form, name: 'Form 2')
    form3 = create(:sword_form, name: 'Form 3')
    tag1 = create(:tag, name: 'Stab')
    tag2 = create(:tag, name: 'Thrust')
    form1.tags << tag1
    form3.tags << tag1
    form3.tags << tag2

    visit sword_forms_path

    expect(page).to have_content 'Sword forms'
    expect(page).to have_no_link 'New sword form', href: new_sword_form_path
    expect(page).to have_link 'Tags', href: tags_path

    # Check the page lists all the forms
    expect(page).to have_content form1.name
    expect(page).to have_content form2.name
    expect(page).to have_content form3.name

    # Check the tags are being displayed
    expect(page).to have_xpath form_tag_selector(form1.name, tag1.name)
    expect(page).to have_xpath form_tag_selector(form3.name, tag1.name)
    expect(page).to have_xpath form_tag_selector(form3.name, tag2.name)
  end

  def form_tag_selector(form, tag)
    # Select the <td> with the form name in an <a>, go to parent,
    # two cells right and check text in an <a> contains tag name
    ".//td/a[text() [normalize-space() = '#{form}'] ]/parent::td/following-sibling::td[2]/a[text() = '#{tag}']"
  end

  scenario 'seeing a tag list on the index page' do
    create(:sword_form, name: 'Form 1')
    tag1 = create(:tag, name: 'Tag 1')
    tag2 = create(:tag, name: 'Tag 2')
    tag3 = create(:tag, name: 'Tag 3')

    visit sword_forms_path

    expect(page).to have_css '#tags-sidebar'
    expect(page).to have_xpath ".//div[@id='tags-sidebar']/h2[text() = 'Tags']"

    # Check the sidebar lists all the tags
    expect(page).to have_link 'Tag 1', href: tag_path(tag1)
    expect(page).to have_link 'Tag 2', href: tag_path(tag2)
    expect(page).to have_link 'Tag 3', href: tag_path(tag3)
  end

  scenario 'seeing a tag list on the individual sword form page' do
    form1 = create(:sword_form, name: 'Form 1')
    tag1 = create(:tag, name: 'Tag 1')
    tag2 = create(:tag, name: 'Tag 2')
    tag3 = create(:tag, name: 'Tag 3')

    visit sword_form_path(form1)

    expect(page).to have_css '#tags-sidebar'
    expect(page).to have_xpath ".//div[@id='tags-sidebar']/h2[text() = 'Tags']"

    # Check the sidebar lists all the tags
    expect(page).to have_link 'Tag 1', href: tag_path(tag1)
    expect(page).to have_link 'Tag 2', href: tag_path(tag2)
    expect(page).to have_link 'Tag 3', href: tag_path(tag3)
  end

  scenario 'seeing the link to create a new form when authenicated on the index page' do
    user = create(:user)
    sign_in user

    create(:sword_form, name: 'Form 1')
    create(:sword_form, name: 'Form 2')
    create(:sword_form, name: 'Form 3')

    visit sword_forms_path

    expect(page).to have_content 'Sword forms'
    expect(page).to have_link 'New sword form', href: new_sword_form_path
    expect(page).to have_link 'Tags', href: tags_path

    # Check the page lists all the forms
    expect(page).to have_content 'Form 1'
    expect(page).to have_content 'Form 2'
    expect(page).to have_content 'Form 3'
  end

  scenario 'viewing a sword form with no tags' do
    form = create(:sword_form, name: 'Form 1', description: 'Test sword form 1')

    visit sword_form_path(form)

    expect(page).to have_content 'Form 1'
    expect(page).to have_content 'Test sword form 1'
    expect(page).to have_no_xpath '//h1/ul'
  end

  scenario 'viewing a sword form with tags' do
    form = create(:sword_form, name: 'Form 1', description: 'Test sword form 1')
    tag = create(:tag, name: 'Tag 1')
    form.tags << tag

    visit sword_form_path(form)

    expect(page).to have_content 'Form 1'
    expect(page).to have_content 'Test sword form 1'

    expect(page).to have_no_xpath '//h1/ul'
    expect(page).to have_link('Tag 1', href: tag_path(tag), count: 2)
  end

  scenario 'editing one of the sword forms' do
    sign_in create(:user)
    form = create(:sword_form, name: 'Form 1', description: 'Test sword form 1')
    tag1 = create(:tag, name: 'Tag 1')
    tag2 = create(:tag, name: 'Tag 2')
    form.tags << tag1

    visit edit_sword_form_path(SwordForm.find_by(name: 'Form 1'))

    expect(page).to have_field 'Name', type: 'text', with: 'Form 1'
    expect(page).to have_field 'Description', type: 'textarea', with: 'Test sword form 1'
    expect(page).to have_checked_field tag1.name
    expect(page).to have_unchecked_field tag2.name
    expect(page).to have_button 'Save my form'

    # Fields for the edited SwordForm
    form_name = 'Edited form'
    form_description = 'Edited description'

    # Edit the fields and save
    fill_in 'Name', with: form_name
    fill_in 'Description', with: form_description
    uncheck tag1.name
    check tag2.name
    click_link_or_button 'Save my form'

    # Page should contain success message
    expect(page).to have_content(I18n.t('sword_forms.update_success'))

    # Should be saved, so pull from database and check
    sf = SwordForm.find_by(name: form_name)
    expect(sf).not_to be_nil
    expect(sf.description).to eq form_description
    expect(sf.tags.count).to eq 1
    expect(sf.tags.first.name).to eq tag2.name
  end

  scenario 'adding one of the new sword forms' do
    user = create(:user)
    tag = create(:tag, name: 'Stabbing')

    sign_in user
    visit new_sword_form_path

    expect(page).to have_field 'Name', type: 'text'
    expect(page).to have_field 'Description', type: 'textarea'
    expect(page).to have_unchecked_field tag.name
    expect(page).to have_button 'Save my form'

    # Fields for the new SwordForm
    form_name = 'New form'
    form_description = 'Description fun'

    # Fill in the fields and save
    fill_in 'Name', with: form_name
    fill_in 'Description', with: form_description
    check tag.name
    click_link_or_button 'Save my form'

    # Page should contain success message
    expect(page).to have_content(I18n.t('sword_forms.create_success'))

    # Should be saved, so pull from database and check
    sf = SwordForm.find_by(name: form_name)
    expect(sf).not_to be_nil
    expect(sf.description).to eq form_description
    expect(sf.tags.count).to eq 1
    expect(sf.tags.first.name).to eq tag.name
  end

  scenario 'deleting a sword form' do
    user = create(:user)
    sf = create(:sword_form, name: 'Delete', description: 'Only form')

    # From the home page, find the only 'Destroy' link and click it
    sign_in user
    visit sword_forms_path
    click_link_or_button 'Destroy'

    # Check it's gone in the database
    sf2 = SwordForm.find_by(name: sf.name)
    expect(sf2).to be_nil
  end
end
# rubocop:enable Metrics/BlockLength
