GoodJob.configuration do |config|
  config.execution_mode = :async
  config.poll_interval = 30
  config.preserve_job_records = true
end
