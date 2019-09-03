class Event < ApplicationRecord
  belongs_to :admin
  has_many :sessions

  validates :name, presence: true, length: { maximum: 50 }
end
