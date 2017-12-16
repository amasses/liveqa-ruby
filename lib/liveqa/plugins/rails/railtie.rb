module LiveQA
  module Plugins
    module Rails
      class Railtie < ::Rails::Railtie

        initializer 'liveqa.middleware' do |app|
          app.config.middleware.use(LiveQA::Plugins::Rack::Middleware)

          if ActiveSupport.const_defined?(:Reloader) && ActiveSupport::Reloader.respond_to?(:to_complete)
            ActiveSupport::Reloader.to_complete do
              LiveQA::Store.clear!
            end
          elsif ActionDispatch.const_defined?(:Reloader) && ActionDispatch::Reloader.respond_to?(:to_cleanup)
            ActionDispatch::Reloader.to_cleanup do
              LiveQA::Store.clear!
            end
          end
        end

      end
    end
  end
end
