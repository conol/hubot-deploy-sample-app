ROOT = File.expand_path('../../..', __FILE__)

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)

listen "#{ROOT}/tmp/sockets/unicorn.sock"
pid    "#{ROOT}/tmp/pids/unicorn.pid"

timeout 30

stdout_path "#{ROOT}/log/unicorn.stdout.log"
stderr_path "#{ROOT}/log/unicorn.stderr.log"

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"

  unless old_pid == server.pid
    begin
     Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
