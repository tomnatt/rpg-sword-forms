require 'rails_helper'

RSpec.describe SwordForm, type: :model do
  it 'must have a name' do
    sf = build(:sword_form, name: 'Foo')
    expect(sf).to be_valid

    sf = build(:sword_form, name: nil)
    expect(sf).to_not be_valid
  end

  it 'must have a description' do
    sf = build(:sword_form, description: 'This is a description')
    expect(sf).to be_valid

    sf = build(:sword_form, description: nil)
    expect(sf).to_not be_valid
  end
end
