class API::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create]
  before_action :set_user, only: [:show, :destroy]

  def show
    # @user = User.find_by(id: params[:id])
    # render user with added info for current user
    if @user && @current_user && @user.id == @current_user.id
      render json: @user, methods: [:name], except: :password_digest
    # render 3rd-party user
    elsif @user
      render json: @user, methods: [:name], except: [:password_digest]
    else
      render json: { server_message: 'Not logged in! (users#show)' }, status: 401
    end
  end

  def create
    user = User.create(user_params)
    if user.persisted?
      token = user.encode_jwt
      render json: { token:, user: user.as_json(only: %i[id email fname lname]) }, except: :password_digest, status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def destroy
    render json: @user.destroy
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.permit(:fname, :lname, :email, :password, :password_confirmation, :time_zone, :password_digest)
  end
end
