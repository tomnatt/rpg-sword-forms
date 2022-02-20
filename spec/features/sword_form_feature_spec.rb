require 'rails_helper'

RSpec.describe 'Accessing the sword forms pages', type: :feature do
  scenario 'seeing the list of games on the index page' do
    create(:sword_form, name: 'Form 1')
    create(:sword_form, name: 'Form 2')
    create(:sword_form, name: 'Form 3')

    visit sword_forms_path

    expect(page).to have_content 'Sword forms'
    expect(page).to have_link('New sword form', href: new_sword_form_path)

    # Check the page lists all the forms
    expect(page).to have_content 'Form 1'
    expect(page).to have_content 'Form 2'
    expect(page).to have_content 'Form 3'
  end

  scenario 'editing one of the sword forms' do
    create(:sword_form, name: 'Form 1', description: 'Test sword form 1')

    visit edit_sword_form_path(SwordForm.find_by(name: 'Form 1'))

    expect(page).to have_field 'Name', type: 'text', with: 'Form 1'
    expect(page).to have_field 'Description', type: 'textarea', with: 'Test sword form 1'
    expect(page).to have_button 'Save my form'
  end

  scenario 'adding one of the new sword forms' do
    visit new_sword_form_path

    expect(page).to have_field 'Name', type: 'text'
    expect(page).to have_field 'Description', type: 'textarea'
    expect(page).to have_button 'Save my form'
  end
end
