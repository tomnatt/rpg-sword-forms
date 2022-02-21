class SwordForm < ApplicationRecord
  validates :name,
            :description, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
