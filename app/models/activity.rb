class Activity < ApplicationRecord
  self.ignored_columns = ["pace"]
  belongs_to :user

  enum category: { run: 0, long_run: 1, workout: 2, race: 3, other: 4 }
  enum difficulty: { easy: 0, moderate: 1, hard: 2 }
  enum unit: { miles: 0, kilometers: 1, meters: 2, yards: 3 }

  has_rich_text :description

  before_validation :calculate_duration
  before_save :calculate_pace

  validates :date, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }
  validates :distance, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :hours, numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true }
  validates :minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                      less_than_or_equal_to: 59, allow_nil: true }
  validates :seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                      less_than_or_equal_to: 59, allow_nil: true }
  validate :require_distance_or_duration
  validate :require_unit_if_distance_set

  private

  def require_distance_or_duration
    errors.add(:base, "Please add a distance or duration") if distance.nil? && duration.nil?
  end

  def require_unit_if_distance_set
    errors.add(:base, "Please select a unit") if distance.present? && unit.nil?
  end

  def calculate_pace
    if unit.present? && distance.present? && duration.present?
      case unit
      when "miles"
        self.calculated_pace = duration / distance
      when "kilometers"
        # 0.6213712
        converted_distance = distance * 0.6213712
        self.calculated_pace = duration / converted_distance
      when "meters"
        # 0.0006213711985
        converted_distance = distance * 0.0006213711985
        self.calculated_pace = duration / converted_distance
      when "yards"
        # 0.0005681818239083977
        converted_distance = distance * 0.0005681818239083977
        self.calculated_pace = duration / converted_distance
      end
    end
  end

  def calculate_duration
    calculated_duration = 0

    calculated_duration += hours * (60 * 60) if hours.present?
    calculated_duration += minutes * 60 if minutes.present?
    calculated_duration += seconds if seconds.present?

    self.duration = calculated_duration unless calculated_duration.zero?
  end
end
