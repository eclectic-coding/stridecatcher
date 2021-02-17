class Total < ApplicationRecord
  belongs_to :user

  enum range: { week: 0 }

  validates :starting_on, :range, presence: true
  validates :user, uniqueness: { scope: %i[starting_on range] }
end
