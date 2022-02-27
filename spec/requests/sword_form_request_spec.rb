require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'SwordForms', type: :request do
  before :each do
    @user = create(:user, name: 'Admin', email: 'admin@example.com')
    sign_in @user
  end

  describe 'GET /index' do
    it 'returns a successful response' do
      get sword_forms_path
      expect(response).to be_successful
    end

    it 'should not require authentication' do
      sign_out @user
      get sword_forms_path
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'returns a succesful response for the show sword form page' do
      form = create(:sword_form)
      get sword_form_path(form)
      expect(response).to be_successful
    end

    it 'should not require authentication' do
      sign_out @user
      form = create(:sword_form)
      get sword_form_path(form)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'returns a succesful response' do
      get new_sword_form_path
      expect(response).to be_successful
    end

    it 'must require authentication' do
      sign_out @user
      get new_sword_form_path
      expect(response).to_not be_successful
    end
  end

  describe 'GET /edit' do
    it 'returns a succesful response' do
      form = create(:sword_form)
      get edit_sword_form_path(form)
      expect(response).to be_successful
    end

    it 'must require authentication' do
      sign_out @user
      form = create(:sword_form)
      get edit_sword_form_path(form)
      expect(response).to_not be_successful
    end
  end
end
# rubocop:enable Metrics/BlockLength
