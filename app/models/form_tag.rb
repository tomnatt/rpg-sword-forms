class FormTag < ApplicationRecord
  belongs_to :sword_form
  belongs_to :tag

  validates :sword_form, uniqueness: { scope: :tag }
end
