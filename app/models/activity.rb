class Activity < ApplicationRecord
  self.ignored_columns = ["pace"]
  belongs_to :user
  belongs_to :shoe, optional: true

  enum category: { run: 0, long_run: 1, workout: 2, race: 3, other: 4 }
  enum difficulty: { easy: 0, moderate: 1, hard: 2 }
  enum unit: { miles: 0, kilometers: 1, meters: 2, yards: 3 }

  has_one :action_text_rich_text, class_name: "ActionText::RichText", as: :record
  has_rich_text :description

  before_validation :calculate_duration
  before_save :calculate_distance_in_miles
  before_save :calculate_pace
  after_save :create_or_update_total
  after_destroy :create_or_update_total
  after_save :update_shoe_distance_in_miles
  after_destroy :update_shoe_distance_in_miles

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

  def calculate_distance_in_miles
    if unit.present? && distance.present?
      case unit
      when "miles"
        self.distance_in_miles = distance
      when "kilometers"
        self.distance_in_miles = distance * 0.6213712
      when "meters"
        self.distance_in_miles = distance * 0.0006213711985
      when "yards"
        self.distance_in_miles = distance * 0.0005681818239083977
      end
    end
  end

  def calculate_pace
    self.calculated_pace = duration / distance_in_miles if distance_in_miles.present? && duration
  end

  def calculate_duration
    calculated_duration = 0

    calculated_duration += hours * (60 * 60) if hours.present?
    calculated_duration += minutes * 60 if minutes.present?
    calculated_duration += seconds if seconds.present?

    self.duration = calculated_duration unless calculated_duration.zero?
  end

  def update_shoe_distance_in_miles
    unless shoe.nil?
      @activities = Activity.where(shoe: shoe)
      total_distance = @activities.sum(:distance_in_miles)
      shoe.update(distance_in_miles: total_distance)
    end
  end

  def create_or_update_total
    starting_on = date.beginning_of_week

    @total = Total.find_or_initialize_by(user: user, starting_on: starting_on, range: "week")
    @activities = Activity.where("date >= ?", starting_on).where("date <= ?",
                                                                 starting_on.end_of_week).where(user: user)

    total_distance = @activities.sum(:distance_in_miles) unless @activities.empty?
    total_duration = @activities.sum(:duration) unless @activities.empty?

    @total.distance = total_distance unless total_distance.nil?
    @total.duration = total_duration unless total_duration.nil?
    @total.save
  end
end
