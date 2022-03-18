require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe SwordForm, type: :model do
  it 'must have a name' do
    sf = build(:sword_form, name: 'Foo')
    expect(sf).to be_valid

    sf = build(:sword_form, name: nil)
    expect(sf).to_not be_valid
  end

  it 'must have a unique name' do
    sf = create(:sword_form, name: 'Form 1')
    expect(sf).to be_valid

    sf2 = build(:sword_form, name: 'Form 1')
    expect(sf2).to_not be_valid
  end

  it 'must have a description' do
    sf = build(:sword_form, description: 'This is a description')
    expect(sf).to be_valid

    sf = build(:sword_form, description: nil)
    expect(sf).to_not be_valid
  end

  it 'may have some tags' do
    sf = create(:sword_form, name: 'Form')
    tag1 = create(:tag, name: 'Tag 1')
    tag2 = create(:tag, name: 'Tag 2')
    sf.tags << tag1

    # Pull back from db to check saving
    sf = SwordForm.find_by(name: 'Form')
    expect(sf).to be_valid
    expect(sf.tags.count).to eq 1

    # Add another tag
    sf.tags << tag2

    # Pull back from db to check saving
    sf = SwordForm.find_by(name: 'Form')
    expect(sf).to be_valid
    expect(sf.tags.count).to eq 2
  end

  it 'must not have the same tag twice' do
    sf = create(:sword_form, name: 'Form')
    tag1 = create(:tag, name: 'Tag 1')
    sf.tags << tag1

    # Pull back from db to check saving
    sf = SwordForm.find_by(name: 'Form')
    expect(sf).to be_valid
    expect(sf.tags.count).to eq 1

    # Adding the tag again will raise an error
    expect { sf.tags << tag1 }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'has a reversible relationship' do
    sf = create(:sword_form, name: 'Form')
    tag = create(:tag, name: 'Tag')
    sf.tags << tag

    # Get the tag and form fresh from the database
    sf = SwordForm.find_by(name: 'Form')
    tag = Tag.find_by(name: 'Tag')

    # check associations both ways
    expect(sf.tags.count).to eq 1
    expect(tag.sword_forms.count).to eq 1
  end

  it 'can be deleted safely' do
    # Deleting the SwordForm should delete the connecting FormTag but not the Tag
    sf = create(:sword_form, name: 'DeleteMe')
    tag = create(:tag, name: 'Survive')
    sf.tags << tag

    expect(SwordForm.all.count).to eq 1
    expect(FormTag.all.count).to eq 1
    expect(Tag.all.count).to eq 1

    sf.destroy!

    expect(SwordForm.all.count).to eq 0
    expect(FormTag.all.count).to eq 0
    expect(Tag.all.count).to eq 1

    tag = Tag.find_by(name: 'Survive')
    expect(tag.sword_forms.count).to eq 0
  end
end
# rubocop:enable Metrics/BlockLength
