require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Tags', type: :request do
  before :each do
    @user = create(:user, name: 'Admin', email: 'admin@example.com')
    sign_in @user
  end

  describe 'GET /index' do
    it 'returns a successful response' do
      get tags_path
      expect(response).to be_successful
    end

    it 'should not require authentication' do
      sign_out @user
      get tags_path
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'returns a successful response' do
      tag = create(:tag)
      get tag_path(tag)
      expect(response).to be_successful
    end

    it 'should not require authentication' do
      sign_out @user
      tag = create(:tag)
      get tag_path(tag)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'returns a successful response' do
      get new_tag_path
      expect(response).to be_successful
    end

    it 'must require authentication' do
      sign_out @user
      get new_tag_path
      expect(response).to_not be_successful
    end
  end

  describe 'GET /edit' do
    it 'returns a successful response' do
      tag = create(:tag)
      get edit_tag_path(tag)
      expect(response).to be_successful
    end

    it 'must require authentication' do
      sign_out @user
      tag = create(:tag)
      get edit_tag_path(tag)
      expect(response).to_not be_successful
    end
  end
end
# rubocop:enable Metrics/BlockLength
