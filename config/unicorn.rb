worker_processes Integer(ENV['UNICORN_WORKERS'] || 4)
timeout 30
preload_app true
listen(ENV['PORT'] || 3000, backlog: Integer(ENV['UNICORN_BACKLOG'] || 200))

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  Sequel::DATABASES.each(&:disconnect) if defined?(Sequel::Model)
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. ' \
         'Wait for master to sent QUIT'
  end
end
