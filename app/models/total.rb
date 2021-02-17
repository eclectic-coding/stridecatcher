class Total < ApplicationRecord
  belongs_to :user

  enum range: { week: 0 }

  validates :starting_on, :range, presence: true
  validates_uniqueness_of :user, scope: %i[starting_on range]
end
