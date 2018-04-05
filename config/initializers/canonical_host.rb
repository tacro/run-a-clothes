require "rack/ssl"

unless Rails.env.development?
  Rails.application.config.middleware.insert_before Rack::SSL, Rack::CanonicalHost, ENV["APP_HOST_NAME"]
end
