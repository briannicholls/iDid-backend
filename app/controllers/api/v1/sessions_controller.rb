class API::V1::SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:session][:email])
    if user&.authenticate(params[:session][:password])
      token = encode_token({
                             user_id: user.id,
                             email: user.email
                           })
      render json: { token:, user: user.as_json(only: %i[id email fname lname]) }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def current_user
    render json: current_user, except: :password_digest
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
