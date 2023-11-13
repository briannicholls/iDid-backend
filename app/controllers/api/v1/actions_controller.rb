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
    if action.save
      render json: action
    else
      render_error action.errors.full_messages
    end
  end

  def delete
    action = Action.find_by(id: params[:id])
    if action&.destroy
      render json: action
    else
      render_error action.errors.full_messages
    end
  end

  private

  def action_params
    params.permit(:reps, :user_id, :counter_id, :value, :unit_of_measure_id)
  end
end
