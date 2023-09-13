module Constants
  FRONTEND_BASE_URL = Rails.application.credentials[:frontend_base_url]
  BACKEND_BASE_URL  = Rails.application.credentials[:backend_base_url]
  GMAIL_USERNAME    = Rails.application.credentials[:gmail_username]
  GMAIL_PASSWORD    = Rails.application.credentials[:gmail_password]
  CORS_ORIGINS      = Rails.application.credentials[:cors_origins].split(',').map(&:strip)
  # For development only; Heroku uses URL for production
  DATABASE_USERNAME = Rails.application.credentials[:database_username]
  DATABASE_PASSWORD = Rails.application.credentials[:database_password]
end
