require 'rails_helper'

RSpec.describe 'Unauthenticated accessing the sword form admin pages', type: :feature do
  scenario 'add sword form page should require authentication' do
    visit new_sword_form_path
    expect(page).to have_content 'You need to sign in'
  end

  scenario 'edit sword form page should require authentication' do
    user = create(:user)
    visit edit_user_path(user)
    expect(page).to have_content 'You need to sign in'
  end
end
