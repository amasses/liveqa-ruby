if defined?(Rack)
  require 'liveqa/plugins/rack/middleware'

  require 'liveqa/plugins/rails/railtie' if defined?(Rails)
end
