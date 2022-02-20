require 'rails_helper'

RSpec.describe 'Accessing the sword forms pages', type: :feature do
  before :each do
    create(:sword_form, name: 'Form 1')
    create(:sword_form, name: 'Form 2')
    create(:sword_form, name: 'Form 3')
  end

  scenario 'seeing the list of games on the index page' do
    visit sword_forms_path

    expect(page).to have_content 'Sword forms'
    expect(page).to have_link('New sword form', href: new_sword_form_path)

    # Check the page lists all the forms
    expect(page).to have_content 'Form 1'
    expect(page).to have_content 'Form 2'
    expect(page).to have_content 'Form 3'
  end
end
