require 'rails_helper'

RSpec.describe User do
  it 'must have a name' do
    user = build(:user, name: 'Steve')
    expect(user).to be_valid

    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it 'must have a unique name' do
    user = create(:user, name: 'Steve')
    expect(user).to be_valid

    user2 = build(:user, name: 'Steve')
    expect(user2).not_to be_valid
  end

  it 'must have an email address' do
    user = build(:user, email: 'bar@example.com')
    expect(user).to be_valid

    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'must have a unique email address' do
    user = create(:user, email: 'bar@example.com')
    expect(user).to be_valid

    user2 = build(:user, email: 'bar@example.com')
    expect(user2).not_to be_valid
  end
end
