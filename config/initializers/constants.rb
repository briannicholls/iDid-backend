# frozen_string_literal: true

module Constants
  FRONTEND_BASE_URL = ENV['FRONTEND_BASE_URL']
  CORS_ORIGINS      = ENV['CORS_ORIGINS'].split(',').map(&:strip)

  # For development only; Heroku uses URL for production
  DATABASE_USERNAME = ENV['DATABASE_USERNAME']
  DATABASE_PASSWORD = ENV['DATABASE_PASSWORD']
end
