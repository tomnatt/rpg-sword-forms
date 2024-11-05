require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Tag do
  it 'must have a name' do
    tag = build(:tag, name: 'Stab')
    expect(tag).to be_valid

    tag = build(:tag, name: nil)
    expect(tag).not_to be_valid
  end

  it 'must have a unique name' do
    tag = create(:tag, name: 'Stab')
    expect(tag).to be_valid

    tag2 = build(:tag, name: 'Stab')
    expect(tag2).not_to be_valid
  end

  it 'may have some sword form' do
    tag = create(:tag, name: 'Tag')
    sf1 = create(:sword_form, name: 'Form 1')
    sf2 = create(:sword_form, name: 'Form 2')
    tag.sword_forms << sf1

    # Pull back out the database to check saving
    tag = described_class.find_by(name: 'Tag')
    expect(tag).to be_valid
    expect(tag.sword_forms.count).to eq 1

    tag.sword_forms << sf2
    tag = described_class.find_by(name: 'Tag')
    expect(tag).to be_valid
    expect(tag.sword_forms.count).to eq 2
  end

  it 'must not have the same sword form twice' do
    tag = create(:tag, name: 'Tag')
    sf1 = create(:sword_form, name: 'Form 1')
    tag.sword_forms << sf1

    # Pull back out the database to check saving
    tag = described_class.find_by(name: 'Tag')
    expect(tag).to be_valid
    expect(tag.sword_forms.count).to eq 1

    # Adding the form again will raise an error
    expect { tag.sword_forms << sf1 }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'has a reversible relationship' do
    tag = create(:tag, name: 'Tag')
    sf = create(:sword_form, name: 'Form')
    tag.sword_forms << sf

    # Get the tag and form fresh from the database
    tag = described_class.find_by(name: 'Tag')
    sf = SwordForm.find_by(name: 'Form')

    # check associations both ways
    expect(tag.sword_forms.count).to eq 1
    expect(sf.tags.count).to eq 1
  end

  it 'can be deleted safely' do
    # Deleting the Tag should delete the connecting FormTag but not the SwordForm
    tag = create(:tag, name: 'DeleteMe')
    sf = create(:sword_form, name: 'Survive')
    tag.sword_forms << sf

    expect(described_class.count).to eq 1
    expect(FormTag.count).to eq 1
    expect(SwordForm.count).to eq 1

    tag.destroy!

    expect(described_class.count).to eq 0
    expect(FormTag.count).to eq 0
    expect(SwordForm.count).to eq 1

    sf = SwordForm.find_by(name: 'Survive')
    expect(sf.tags.count).to eq 0
  end
end
# rubocop:enable Metrics/BlockLength
