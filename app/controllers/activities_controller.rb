class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: %i[show]
  before_action :calculate_duration, only: [:create]

  def show; end

  def new
    @activity = current_user.activities.build(date: Time.zone.now)
  end

  def create
    @activity = current_user.activities.create(activity_params)
    if @activity.save
      redirect_to @activity, notice: "Created Activity"
    else
      render "new"
    end
  end


  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def calculate_duration
    calculated_duration = 0

    calculated_duration += params[:activity][:hours].to_i * (60 * 60) if params[:activity][:hours].present?
    calculated_duration += params[:activity][:minutes].to_i * 60 if params[:activity][:minutes].present?
    calculated_duration += params[:activity][:seconds].to_i if params[:activity][:seconds].present?

    params[:activity][:duration] = calculated_duration unless calculated_duration.zero?
  end

  def activity_params
    params
      .require(:activity)
      .permit(:duration, :category, :distance, :difficulty, :unit, :date)
  end
end
