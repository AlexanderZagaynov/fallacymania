require 'logging'

class Logging::Logger

  # defaults
  root.add_appenders Logging.appenders.stdout

  # Rails compatibility
  # https://github.com/TwP/logging/blob/master/lib/logging/rails_compat.rb
  # manually, since it's required before Rails (for Unicorn)
  def formatter
  end

end
