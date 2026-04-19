# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      origins '*'
    else
      # Ex: ENV["CORS_ALLOWED_ORIGINS"]="https://app.com,https://admin.com"
      origins ENV.fetch('CORS_ALLOWED_ORIGINS', '').split(',')
    end

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
