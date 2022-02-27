require 'rails_helper'

RSpec.describe 'Unauthenticated accessing the user admin pages', type: :feature do
  scenario 'list users page should require authentication' do
    visit users_path
    expect(page).to have_content 'You need to sign in'
  end

  scenario 'show user page should require authentication' do
    user = create(:user)
    visit user_path(user)
    expect(page).to have_content 'You need to sign in'
  end

  scenario 'add user page should require authentication' do
    visit new_user_path
    expect(page).to have_content 'You need to sign in'
  end

  scenario 'edit user page should require authentication' do
    user = create(:user)
    visit edit_user_path(user)
    expect(page).to have_content 'You need to sign in'
  end
end
