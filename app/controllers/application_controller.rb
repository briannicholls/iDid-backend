# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  respond_to :html, :json
  before_action :authorize_request, except: %i[redirect_to_app reset_password leaders show_reset_password_form]
  before_action :conditionally_authorize_request, only: [:leaders]

  def logged_in?
    !!@current_user
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
  end

  def render_error(errors)
    render json: { errors: }, status: :unprocessable_entity
  end

  def current_version
    request.headers['HTTP_X_APP_VERSION']
  end

  private

  def authorize_request
    header = request.headers['Authorization']
    @token = header.split(' ').last if header
    begin
      decoded = decode_token(@token)
      @current_user = User.find(decoded[0]['user_id'])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def public_request?
    params[:public] == 'true'
  end

  def conditionally_authorize_request
    authorize_request unless public_request?
  end

  # Checks if the request is from a mobile client
  def mobile_request?
    # request.headers['Client-Type'] == 'Mobile'
    user_agent = request.user_agent
    if user_agent =~ /Mobile|webOS|Android/
      true
    else
      false
    end
  end
end
