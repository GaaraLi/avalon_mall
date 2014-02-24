APP_PATH = "/var/www/m/"
UNICORN_LOG_DIR = "#{APP_PATH}/shared/log"
PID_DIR = "#{APP_PATH}/shared/pids"

worker_processes 4
working_directory  "#{APP_PATH}/current"

listen "/tmp/unicorn.avalon_mall.sock", :backlog => 64
listen 80, :tcp_nopush => true

timeout 30

pid "#{PID_DIR}/unicorn.pid"

stderr_path "#{UNICORN_LOG_DIR}/unicorn.stderr.log"
stdout_path "#{UNICORN_LOG_DIR}/unicorn.stdout.log"

preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  old_pid = "#{APP_PATH}/shared/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
   	  rescue Errno::ENOENT, Errno::ESRCH
   	    puts "Send 'QUIT' signal to unicorn error!"
  	end
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
