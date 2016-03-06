require_relative 'boot'

if %w(production staging).include? (ENV['RAILS_ENV'] || ENV['RACK_ENV']).downcase

  app_home = File.expand_path '~'

  working_directory File.join app_home, 'current'
  pid               File.join app_home, *%w(pids unicorn.pid)
  listen            File.join app_home, *%w(sockets unicorn.sock)
  preload_app       true
  worker_processes  4

else

  app_root = Bundler.root.to_path

  working_directory app_root
  pid               File.join app_root, *%w(tmp pids unicorn.pid)
  listen            3000
  worker_processes  2

end

timeout 30
logger Logging.logger['Unicorn']

before_fork do |server, worker|
  defined? ActiveRecord::Base and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Logging.reopen
  defined? ActiveRecord::Base and ActiveRecord::Base.establish_connection
end
