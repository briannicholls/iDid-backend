class API::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]

  def create
    user = User.find_by_email(params[:session][:email])
    if user&.valid_password?(params[:session][:password])
      token = encode_token({
                             user_id: user.id,
                             email: user.email
                           })
      render json: { token:, user: user.as_json(only: %i[id email fname lname]) }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def fetch_current_user
    # Here, the @current_user instance variable should already be set by the authorize_request before_action.
    if @current_user
      # binding.pry
      render json: { token: @token, user: @current_user.as_json(only: %i[id email fname lname]) }, status: :ok
    else
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def app_state
    render json: session[:state]
  end

  def set_state
    session[:state] = params[:session][:_json]
    render json: session[:state]
  end

  def destroy
    session.clear
    render json: { server_message: 'You Logged Out!' }
  end
end
