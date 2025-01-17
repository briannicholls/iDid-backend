# frozen_string_literal: true

class API::V1::ActionsController < ApplicationController
  def index
    if params[:user_id]
      actions = Action.where(user_id: params[:user_id]).order(created_at: :desc)
      render json: actions
    else
      render_error ['Could not get actions for user!']
    end
  end

  def create
    action = Action.new(action_params)
    counter = Counter.find_by(id: params[:counter_id])
    action.counter_id = counter.id if counter
    # TODO: fix on FE - it sometimes sends unit_of_measure_id regardless of dimension
    action.unit_of_measure_id = nil unless counter.dimension != 'default'
    if action.save
      render json: action
    else
      render_error action.errors.full_messages
    end
  end

  def destroy
    action = Action.find(params[:id])
    if action&.destroy
      actions = Action.for_user(@current_user).order(created_at: :desc)
      render json: actions
    else
      render_error action.errors.full_messages
    end
  end

  def feed
    actions = @current_user.feed
    render json: actions
  end

  private

  def action_params
    params.permit(:reps, :user_id, :counter_id, :value, :unit_of_measure_id)
  end
end
