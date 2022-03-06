require 'rails_helper'

RSpec.describe Tag, type: :model do
  it 'must have a name' do
    tag = build(:tag, name: 'Stab')
    expect(tag).to be_valid

    tag = build(:tag, name: nil)
    expect(tag).to_not be_valid
  end

  it 'must have a unique name' do
    tag = create(:tag, name: 'Stab')
    expect(tag).to be_valid

    tag2 = build(:tag, name: 'Stab')
    expect(tag2).to_not be_valid
  end
end
