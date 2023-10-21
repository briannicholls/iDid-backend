# frozen_string_literal: true

class API::V1::ActionsController < ApplicationController
  def index
    if params[:user_id]
      actions = Action.where(user_id: params[:user_id]).order(created_at: :desc)
      render json: actions
    else
      render json: { server_message: 'Could not get actions for user!' }, status:
    end
  end

  def create
    action = Action.new(action_params)
    counter = Counter.find_by(id: params[:counter_id])
    action.counter_id = counter.id if counter
    if action.save
      render json: action
    else
      render json: { server_message: 'Unable to create Action!' }
    end
  end

  private

  def action_params
    params.permit(:reps, :user_id, :counter_id, :value)
  end
end
