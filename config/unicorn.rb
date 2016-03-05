env = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'

if %w(production staging).include? env

  app_home = File.expand_path '~'
  log_file = File.join app_home, *%w(logs unicorn.log)

  working_directory File.join app_home, 'current'
  stderr_path       log_file
  stdout_path       log_file
  pid               File.join app_home, *%w(pids unicorn.pid)
  listen            File.join app_home, *%w(sockets unicorn.sock)
  preload_app       true
  worker_processes  4

else

  app_root = File.expand_path '../../',  __FILE__
  log_root = File.join app_root, 'log'

  # reset current logs (TODO: must reside somewhere else, but run identically for dev/test only)
  Dir[File.join log_root, '*.log'].grep(/(?<!\.prev)\.log$/) do |file|
    next unless File.file?(file) && (ext_index = file.rindex(File.extname file) || -1)
    File.rename file, file.dup.insert(ext_index, '.prev')
  end

  working_directory app_root
  stderr_path       File.join log_root, "unicorn.stderr.#{env}.log"
  stdout_path       File.join log_root, "unicorn.stdout.#{env}.log"
  pid               File.join app_root, *%w(tmp pids unicorn.pid)
  listen            3000
  worker_processes  2

end

timeout 30

before_fork do |server, worker|
  defined? ActiveRecord::Base and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined? ActiveRecord::Base and ActiveRecord::Base.establish_connection
end
