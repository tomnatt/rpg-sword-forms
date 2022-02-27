require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Accessing the user admin pages', type: :feature do
  before :each do
    @user = create(:user)
    sign_in @user
  end

  scenario 'seeing a list of users on the index page' do
    create(:user, name: 'User 1', email: 'user1@example.com')
    create(:user, name: 'User 2', email: 'user2@example.com')
    create(:user, name: 'User 3', email: 'user3@example.com')

    visit users_path
    expect(page).to have_content('User 1')
    expect(page).to have_selector('tr.user', count: 4)
  end

  scenario 'viewing a user' do
    user = create(:user, name: 'User 1', email: 'user1@example.com')

    visit user_path(user)
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
  end

  scenario 'adding a user' do
    visit new_user_path
    expect(page).to have_field 'Name', type: 'text'
    expect(page).to have_field 'Email', type: 'text'
    expect(page).to have_field 'Password', type: 'password'
  end

  scenario 'editing a user' do
    user = create(:user, name: 'User 1', email: 'user1@example.com')

    visit edit_user_path(user)
    expect(page).to have_field 'Name', type: 'text', with: user.name
    expect(page).to have_field 'Email', type: 'text', with: user.email
    expect(page).to_not have_field 'Password', type: 'password'
  end
end
# rubocop:enable Metrics/BlockLength
