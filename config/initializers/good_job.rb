GoodJob.configuration do |config|
  config.active_record_parent_class = 'ActiveRecord::Base'
  config.execution_mode = :async
  config.poll_interval = 30

  config.database_configuration = {
    adapter: 'postgresql',
    encoding: 'unicode',
    pool: ENV.fetch("RAILS_MAX_THREADS") { 5 },
    username: ENV['DB_USERNAME'],
    password: ENV['DB_PASSWORD'],
    host: ENV['DB_HOST'] || 'localhost',
    database: ENV['GOOD_JOB_DATABASE'] || 'search_engine_development' # Change as per environment
  }
end
