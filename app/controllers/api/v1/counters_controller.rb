class API::V1::CountersController < ApplicationController
  def index
    # if current user is present, order counters by user's most recent counter
    counters = Counter.all.order(:name)
    # TODO: remove version check after 2.5.1 deploys
    if @current_user && current_version && Gem::Version.new(current_version) >= Gem::Version.new('2.5.1')
      render json: {
        recent: counters.for_user(@current_user.id),
        counters:
      }
    elsif current_version && Gem::Version.new(current_version) >= Gem::Version.new('2.5.1')
      render json: { recent: [], counters: }
    else
      render json: counters
    end
  end

  def create
    counter = Counter.new(counter_params)
    counter.dimension = 'default' if counter.dimension.blank?
    counter.name = if counter.track_reps == true
                     counter.name.strip
                   else
                     counter.name.strip
                   end
    counter.created_by = @current_user.id if @current_user
    if counter.save
      render json: counter, status: :created
    else
      render_error counter.errors.full_messages
    end
  end

  def update
    counter = Counter.find(params[:id])
    if counter.update(counter_params)
      render json: counter
    else
      render_error counter.errors.full_messages
    end
  end

  def leaders
    render json: {
      month: Counter.leaders(1.month.ago),
      week: Counter.leaders(1.week.ago),
      all_time: Counter.leaders(DateTime.new(2020))
    }
  end

  def show
    render json: Counter.find(params[:id])
  end

  private

  def counter_params
    params.require(:counter).permit(:name, :dimension, :measurement_unit, :track_reps, :name_singular, :name_plural,
                                    :link, :description)
  end
end
