Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*' # Adjust as per your frontend URL in production
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
    end
  end
  