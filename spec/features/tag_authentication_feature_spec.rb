require 'rails_helper'

RSpec.describe 'Unauthenticated accessing the tag admin pages' do
  scenario 'add tag page should require authentication' do
    visit new_tag_path
    expect(page).to have_content 'You need to sign in'
  end

  scenario 'edit tag page should require authentication' do
    tag = create(:tag)
    visit edit_tag_path(tag)
    expect(page).to have_content 'You need to sign in'
  end
end
