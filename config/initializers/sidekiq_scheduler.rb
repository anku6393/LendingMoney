require 'sidekiq-scheduler'

Sidekiq.schedule = {
  'calculate_interest' => {
    'cron' => '*/1 * * * *', # Runs every minute
    'class' => 'InterestCalculatorWorker',
    'args' => []
  }
}

Sidekiq::Scheduler.reload_schedule!
