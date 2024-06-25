# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :configure_permitted_parameters, only: [:create]
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    Rails.logger.debug "Reset Password Parameters: #{params.inspect}"
    Rails.logger.debug "Parameters: #{params.inspect}"
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    super
  end

  protected

    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password])
    devise_parameter_sanitizer.permit(:reset_password, keys: [:email, :reset_password_token])
  end

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end
end
