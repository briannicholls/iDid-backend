class API::V1::CountersController < ApplicationController

  def index
    render json: Counter.all
  end

  def create
    counter = Counter.create(counter_params)
    if counter.persisted?
      render json: Counter.all
    else
      # alert('Counter could not be saved. Perhaps it already exists?')
      render json: Counter.all
    end
  end

  def leaders
    if params[:q]
      if params[:q] == 'month'
        render json: Counter.leaders(1.month.ago)
      elsif params[:q] == 'week'
        render json: Counter.leaders(1.week.ago)
      else
        render json: {server_message: 'invalid time range'}
      end
    else # render all leaders
      render json: Counter.leaders(DateTime.new(2020))
    end
  end

  private

  def counter_params
    params.require(:counter).permit(:name, :kind, :measurement_unit)
  end

end
