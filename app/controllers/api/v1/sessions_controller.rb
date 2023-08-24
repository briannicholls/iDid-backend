class API::V1::SessionsController < ApplicationController

  def get_current_user
    render json: current_user, except: :password_digest
  end

  def get_state
    render json: session[:state]
  end

  def set_state
    session[:state] = params[:session][:_json]
    render json: session[:state]
  end

  def login
    params[:session][:email] = params[:session][:email].downcase
    user = User.find_by(email: params[:session][:email])
    if user && user.valid_password?(params[:session][:password])
      session[:user_id] = user.id
      render json: user
    else
      render json: { server_message: 'Incorrect email/password combination!' }, status: 401
    end
  end

  def destroy
    session.clear
    render json: {server_message: 'You Logged Out!'}
  end

end
