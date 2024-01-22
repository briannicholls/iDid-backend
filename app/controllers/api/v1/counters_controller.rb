class API::V1::CountersController < ApplicationController

  def index
    render json: Counter.all.order(:name)
  end

  def create
    counter = Counter.new(counter_params)
    counter.dimension = 'default' if counter.dimension.blank?
    if counter.track_reps == true
      counter.name = counter.name.strip.pluralize
    else
      counter.name = counter.name.strip
    end
    counter.created_by = @current_user.id if @current_user
    if counter.save
      render json: counter, status: :created
    else
      render_error counter.errors.full_messages
    end
  end

  def leaders
    render json: {
      month:    Counter.leaders(1.month.ago),
      week:     Counter.leaders(1.week.ago),
      all_time: Counter.leaders(DateTime.new(2020))
    }
  end

  def show
    render json: Counter.find(params[:id])
  end

  private

  def counter_params
    params.require(:counter).permit(:name, :dimension, :measurement_unit, :track_reps, :name_singular, :name_plural)
  end
end
