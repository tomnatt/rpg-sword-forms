class SwordForm < ApplicationRecord
  has_many :form_tags, dependent: :destroy
  has_many :tags, through: :form_tags

  validates :name,
            :description, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
