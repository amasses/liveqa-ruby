##
# Rack & Rails
#
if defined?(Rack)
  require 'liveqa/plugins/rack/middleware'

  if defined?(Rails)
    require 'liveqa/plugins/rails/railtie'
    require 'liveqa/plugins/rails/middleware_data'
  end
end

##
# Sidekiq
#
require 'liveqa/plugins/sidekiq/load' if defined?(Sidekiq)
