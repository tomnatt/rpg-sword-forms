require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Accessing the tag pages' do
  scenario 'seeing the list of tags on the index page' do
    create(:tag, name: 'Tag 1')
    create(:tag, name: 'Tag 2')
    create(:tag, name: 'Tag 3')

    visit tags_path

    expect(page).to have_content 'Tags'
    expect(page).to have_no_link 'New tag', href: new_tag_path
    expect(page).to have_link 'Sword forms', href: sword_forms_path

    # Check the page lists all the tags
    expect(page).to have_content 'Tag 1'
    expect(page).to have_content 'Tag 2'
    expect(page).to have_content 'Tag 3'
  end

  scenario 'seeing the link to create a new tag when authenicated on the index page' do
    user = create(:user)
    sign_in user

    create(:tag, name: 'Tag 1')
    create(:tag, name: 'Tag 2')
    create(:tag, name: 'Tag 3')

    visit tags_path

    expect(page).to have_content 'Tags'
    expect(page).to have_link 'New tag', href: new_tag_path
    expect(page).to have_link 'Sword forms', href: sword_forms_path

    # Check the page lists all the tags
    expect(page).to have_content 'Tag 1'
    expect(page).to have_content 'Tag 2'
    expect(page).to have_content 'Tag 3'
  end

  scenario 'viewing a tag without forms' do
    tag = create(:tag, name: 'Stabbing')

    visit tag_path(tag)

    expect(page).to have_content 'Stabbing'
    expect(page).to have_no_xpath('//h1/ul')
  end

  scenario 'viewing a tag with sword forms' do
    tag = create(:tag, name: 'Stabbing')
    form1 = create(:sword_form, name: 'Form 1')
    form1.tags << tag
    form2 = create(:sword_form, name: 'Form 2')
    form2.tags << tag
    form3 = create(:sword_form, name: 'Form 3')
    form3.tags << tag

    visit tag_path(tag)

    expect(page).to have_content 'Stabbing'
    expect(page).to have_link 'Form 1', href: sword_form_path(form1)
    expect(page).to have_content form1.description
    expect(page).to have_xpath form_tag_selector(form1.name, tag.name)

    expect(page).to have_link 'Form 2', href: sword_form_path(form2)
    expect(page).to have_content form2.description
    expect(page).to have_xpath form_tag_selector(form2.name, tag.name)

    expect(page).to have_link 'Form 3', href: sword_form_path(form3)
    expect(page).to have_content form3.description
    expect(page).to have_xpath form_tag_selector(form3.name, tag.name)
  end

  scenario 'seeing a tag list on the individual tag page' do
    tag1 = create(:tag, name: 'Tag 1')
    tag2 = create(:tag, name: 'Tag 2')
    tag3 = create(:tag, name: 'Tag 3')
    form1 = create(:sword_form, name: 'Form 1')
    form1.tags << tag1

    visit tag_path(tag1)

    expect(page).to have_css '#tags-sidebar'
    expect(page).to have_xpath ".//div[@id='tags-sidebar']/h2[text() = 'Tags']"

    # Check the sidebar lists all the tags
    expect(page).to have_link 'Tag 1', href: tag_path(tag1)
    expect(page).to have_link 'Tag 2', href: tag_path(tag2)
    expect(page).to have_link 'Tag 3', href: tag_path(tag3)
  end

  def form_tag_selector(form, tag)
    # Select the <td> with the form name in an <a>, go to parent,
    # two cells right and check text in an <a> contains tag name
    ".//td/a[text() [normalize-space() = '#{form}'] ]/parent::td/following-sibling::td[2]/a[text() = '#{tag}']"
  end

  scenario 'editing one of the tags' do
    user = create(:user)
    sign_in user
    create(:tag, name: 'Stabbing')

    visit edit_tag_path(Tag.find_by(name: 'Stabbing'))

    expect(page).to have_field 'Name', type: 'text', with: 'Stabbing'
    expect(page).to have_button 'Save my tag'

    # Fields for the edited Tag
    tag_name = 'Edited'

    # Fill in the fields and save
    fill_in 'Name', with: tag_name
    click_link_or_button 'Save my tag'

    # Page should contain success message
    expect(page).to have_content(I18n.t('tags.update_success'))

    # Should be saved, so pull from database and check
    tag = Tag.find_by(name: tag_name)
    expect(tag).not_to be_nil
    expect(tag.sword_forms.count).to eq 0
  end

  scenario 'adding one of the new tags' do
    user = create(:user)
    sign_in user
    visit new_tag_path

    expect(page).to have_field 'Name', type: 'text'
    expect(page).to have_button 'Save my tag'

    # Fields for the new Tag
    tag_name = 'New Tag'

    # Fill in the fields and save
    fill_in 'Name', with: tag_name
    click_link_or_button 'Save my tag'

    # Page should contain success message
    expect(page).to have_content(I18n.t('tags.create_success'))

    # Should be saved, so pull from database and check
    tag = Tag.find_by(name: tag_name)
    expect(tag).not_to be_nil
    expect(tag.sword_forms.count).to eq 0
  end

  scenario 'deleting a tag' do
    user = create(:user)
    tag = create(:tag, name: 'Delete')

    # From the home page, find the only 'Destroy' link and click it
    sign_in user
    visit tags_path
    click_link_or_button 'Destroy'

    # Check it's gone in the database
    tag2 = Tag.find_by(name: tag.name)
    expect(tag2).to be_nil
  end
end
# rubocop:enable Metrics/BlockLength
