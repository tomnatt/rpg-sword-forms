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
    expect(page).to have_button 'Arise, person'

    # Fields for the new User
    user_name = 'New User'
    user_email = 'example@example.com'
    user_password = 'password1'

    # Fill in the fields and save
    fill_in 'Name', with: user_name
    fill_in 'Email', with: user_email
    fill_in 'Password', with: user_password
    click_button 'Arise, person'

    # Page should contain success message
    expect(page).to have_content(I18n.t('users.create_success'))

    # Should be saved, so pull from database and check
    user = User.find_by(name: user_name)
    expect(user).to_not be nil
    expect(user.email).to eq user_email
  end

  scenario 'editing a user' do
    user = create(:user, name: 'User 1', email: 'user1@example.com')

    visit edit_user_path(user)
    expect(page).to have_field 'Name', type: 'text', with: user.name
    expect(page).to have_field 'Email', type: 'text', with: user.email
    expect(page).to_not have_field 'Password', type: 'password'
    expect(page).to have_button 'Arise, person'

    # Fields for the edited User
    user_name = 'Edited'
    user_email = 'user2@example.com'

    # Fill in the fields and save
    fill_in 'Name', with: user_name
    fill_in 'Email', with: user_email
    click_button 'Arise, person'

    # Page should contain success message
    expect(page).to have_content(I18n.t('users.update_success'))

    # Should be saved, so pull from database and check
    user = User.find_by(name: user_name)
    expect(user).to_not be nil
    expect(user.email).to eq user_email
  end

  scenario 'deleting a user' do
    u = create(:user, name: 'Delete', email: 'delete@example.com')

    # From the user listing, find the correct 'Destroy' link and click it
    visit users_path

    # Select the <td> with the user name, go four cells right and click the (Destroy) link
    xpath = ".//td[text() [normalize-space() = '#{u.name}'] ]/following-sibling::td[4]/a[text() = 'Destroy']"
    # [contains(text(), 'Destroy')]"
    find(:xpath, xpath).click

    # Check it's gone in the database
    u2 = User.find_by(name: u.name)
    expect(u2).to be nil
  end
end
# rubocop:enable Metrics/BlockLength
