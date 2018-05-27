namespace :deploy do
  after :start, :start_unicorn do
    invoke 'unicorn:start'
  end

  after :stop, :stop_unicorn do
    invoke 'unicorn:stop'
  end

  after :restart, :restart_unicorn do
    begin
      invoke "unicorn:restart"
    rescue SSHKit::Runner::ExecuteError
      invoke "unicorn:start"
    end
  end
end

namespace :unicorn do
  desc "Start Unicorn"
  task :start do
    on roles(:web) do
      execute :sudo, :start, "unicorn"
    end
  end

  desc "Stop Unicorn"
  task :stop do
    on roles(:web) do
      execute :sudo, :stop, "unicorn"
    end
  end

  desc "Restart Unicorn"
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      execute :sudo, :restart, "unicorn"
    end
  end
end