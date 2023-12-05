# frozen_string_literal: true
class ApplicationController < ActionController::API
  respond_to :html, :json
  before_action :authorize_request, except: %i[redirect_to_app reset_password leaders]
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
end
