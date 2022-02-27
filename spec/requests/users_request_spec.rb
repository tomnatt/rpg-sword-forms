require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Users', type: :request do
  before :each do
    @user = create(:user, name: 'Admin', email: 'admin@example.com')
    sign_in @user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get users_path
      expect(response).to be_successful
    end

    it 'must require authentication' do
      sign_out @user
      get users_path
      expect(response).to_not be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      u = create(:user)
      get user_path(u)
      expect(response).to be_successful
    end

    it 'must require authentication' do
      sign_out @user
      u = create(:user)
      get user_path(u)
      expect(response).to_not be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_user_path
      expect(response).to be_successful
    end

    it 'must require authentication' do
      sign_out @user
      get new_user_path
      expect(response).to_not be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      u = create(:user)
      get edit_user_path(u)
      expect(response).to be_successful
    end

    it 'must require authentication' do
      sign_out @user
      u = create(:user)
      get edit_user_path(u)
      expect(response).to_not be_successful
    end
  end
end
# rubocop:enable Metrics/BlockLength
