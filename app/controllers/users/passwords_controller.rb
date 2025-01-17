# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :authorize_request, only: %i[create edit]

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      Rails.logger.info "Successfully sent reset password instructions to #{resource.email}"
      render json: { message: 'Email sent successfully.' }, status: 200
    else
      Rails.logger.error "Failed to send reset password instructions to #{resource.email}"
      Rails.logger.error resource.errors.full_messages
      render json: { errors: resource.errors.full_messages }, status: 422
    end
  end

  def redirect_to_app
    token = params[:token]
    user_agent = request.user_agent
    if user_agent =~ /Mobile|webOS|Android/
      # Mobile redirection logic
      redirect_to mobile_deep_link_url(token)
    else
      # Desktop redirection logic
      redirect_to api_v1_reset_password_form_path(token:)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   @token = params[:reset_password_token]
  #   if Rails.env.development?
  #     redirect_to "exp://low94oa.nichol88.8080.exp.direct/--/reset-password?token=#{@token}"
  #   else
  #     redirect_to "idid://reset-password?token=#{@token}"
  #   end
  # end

  # PUT /resource/password
  def update
    # Reset the password for the resource (user) by calling reset_password_by_token
    # This will find the user with the provided reset_password_token and update the password
    self.resource = resource_class.reset_password_by_token(resource_params)

    # This yields the resource (user) for further customization if a block is provided
    yield resource if block_given?

    # Check if there are any errors after resetting the password
    if resource.errors.empty?
      # If there are no errors, send a JSON response with a success message
      render json: { message: 'Password reset successfully.' }, status: :ok
    else
      # If there are errors (e.g., invalid token, mismatched passwords), send a JSON response with errors
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  def mobile_deep_link_url(token)
    if Rails.env.development?
      "exp://idid.ngrok.io/--/reset-password?token=#{token}"
    else
      "idid://reset-password?token=#{token}"
    end
  end
end
