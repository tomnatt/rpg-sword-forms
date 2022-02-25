require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    it 'renders a successful response' do
      get users_path
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      user = create(:user)

      get user_path(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_user_path
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      user = create(:user)

      get edit_user_path(user)
      expect(response).to be_successful
    end
  end
end
# rubocop:enable Metrics/BlockLength
