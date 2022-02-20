require 'rails_helper'

RSpec.describe 'SwordForms', type: :request do
  it 'returns a successful response for the index page' do
    get sword_forms_path
    expect(response).to be_successful
  end

  it 'returns a succesful response for the new game page' do
    get new_sword_form_path
    expect(response).to be_successful
  end

  it 'returns a succesful response for the edit game page' do
    form = build(:sword_form)
    form.save!

    get edit_sword_form_path(form.id)
    expect(response).to be_successful
  end
end
