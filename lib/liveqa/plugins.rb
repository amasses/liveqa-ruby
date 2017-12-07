##
# Rack & Rails
#
if defined?(Rack)
  require 'liveqa/plugins/rack/middleware'

  require 'liveqa/plugins/rails/railtie' if defined?(Rails)
end

##
# Sidekiq
#
require 'liveqa/plugins/sidekiq/load' if defined?(Sidekiq)
