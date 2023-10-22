# frozen_string_literal: true

module Constants
  FRONTEND_BASE_URL = Rails.application.credentials[:frontend_base_url]
  CORS_ORIGINS      = Rails.application.credentials[:cors_origins].split(',').map(&:strip)

  # For development only; Heroku uses URL for production
  DATABASE_USERNAME = Rails.application.credentials[:database_username]
  DATABASE_PASSWORD = Rails.application.credentials[:database_password]
end
