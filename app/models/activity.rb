class Activity < ApplicationRecord
  belongs_to :user

  enum category: { run: 0, long_run: 1, workout: 2, race: 3, other: 4 }
  enum difficulty: { easy: 0, moderate: 1, hard: 2 }
  enum unit: { miles: 0, kilometers: 1, meters: 2, yards: 3 }

  validates :date, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }
  validates :distance, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }
  validate :require_distance_or_duration
  validate :require_unit_if_distance_set

  private

  def require_distance_or_duration
    errors.add(:base, "Please add a distance or duration") if distance.nil? && duration.nil?
  end

  def require_unit_if_distance_set
    errors.add(:base, "Please select a unit") if self.distance.present? && self.unit.nil?
  end
end
