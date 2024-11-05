require 'rails_helper'

RSpec.describe 'Root page' do
  it 'returns a successful response for the root page' do
    get root_path
    expect(response).to be_successful
  end
end
