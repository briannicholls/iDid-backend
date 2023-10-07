class API::V1::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[create destroy]

  def create
    user = User.find_by_email(params[:session][:email])
    if user.nil?
      render json: { errors: ['User not found'] }, status: :not_found
    elsif !user.valid_password?(params[:session][:password])
      render json: { errors: ['Incorrect password'] }, status: :unauthorized
    else # Generate token
      token = user.encode_jwt
      render json: { token:, user: user.as_json(only: %i[id email fname lname]) }, status: :ok
    end
  end

  def fetch_current_user
    # Here, the @current_user instance variable should already be set by the authorize_request before_action.
    if @current_user
      render json: { token: @token, user: @current_user.as_json(only: %i[id email fname lname]) }, status: :ok
    else
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def reset_password
    user = User.with_reset_password_token(reset_password_params[:token])

    if user&.reset_password_period_valid?
      if user.reset_password(reset_password_params[:new_password], reset_password_params[:new_password_confirmation])
        render_success(user)
      else
        render_error(user.errors.full_messages)
      end
    else
      render_error(['Token is invalid or expired'])
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

  private

  def render_success(user)
    render json: {
      token: user.encode_jwt,
      user: user.as_json(only: %i[id email fname lname])
    }, except: :password_digest, status: 200
  end

  def reset_password_params
    params.permit(:token, :new_password, :new_password_confirmation)
  end
end
