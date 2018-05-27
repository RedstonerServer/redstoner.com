workers 2

threads 2, 4

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

bind "localhost:8080"

stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
