# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :authorize_request, only: [:create]

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   self.resource = resource_class.send_reset_password_instructions(resource_params)

  #   if successfully_sent?(resource)
  #     if request.format.json?
  #       render json: { success: 'Email sent' }, status: :ok
  #     else
  #       respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
  #     end
  #   else
  #     if request.format.json?
  #       render json: { errors: 'Email not found' }, status: :unprocessable_entity
  #     else
  #       respond_with(resource)
  #     end
  #   end
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
