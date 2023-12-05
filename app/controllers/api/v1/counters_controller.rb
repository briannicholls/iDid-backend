class API::V1::CountersController < ApplicationController

  def index
    render json: Counter.all.order(:name)
  end

  def create
    counter = Counter.create(counter_params)
    if counter.persisted?
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

  private

  def counter_params
    params.require(:counter).permit(:name, :dimension, :measurement_unit, :track_reps, :name_singular, :name_plural)
  end
end
