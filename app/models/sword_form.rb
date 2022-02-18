class SwordForm < ApplicationRecord
  validates :name,
            :description, presence: true
end
