class API::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create]
  before_action :set_user, only: %i[show destroy follow]
  serialization_scope :current_user

  def show
    # render user with added info for current user
    if @user && @current_user && @user.id == @current_user.id
      render json: @user, methods: [:name], except: :password_digest
    # render 3rd-party user
    elsif @user
      render json: @user
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

  def follow
    # if user is already followed, unfollow
    if @current_user.followed_users.find_by(following_id: @user.id)
      @current_user.followed_users.find_by(following_id: @user.id).destroy
      render json: @user
    else
      follow = @current_user.followed_users.build(following_id: @user.id)
      follow.save
      if follow.persisted?
        render json: @user
      else
        render json: { errors: follow.errors.full_messages }, status: 422
      end
    end
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.permit(:fname, :lname, :email, :password, :password_confirmation, :time_zone, :password_digest)
  end
end
