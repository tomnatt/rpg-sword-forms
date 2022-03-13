class Tag < ApplicationRecord
  has_many :form_tags, dependent: :destroy
  has_many :sword_forms, through: :form_tags

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
