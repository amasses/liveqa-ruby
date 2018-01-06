module LiveQA
  module Plugins
    module Rails
      class MiddlewareData

        class << self

          def store_data(request = nil)
            store_request_data(request) if request
          end

          private

          def store_request_data(request)
            object = LiveQA::Store.get(:request) || {}

            LiveQA::Store.set(
              :request,
              object.merge(id: request.env['action_dispatch.request_id'])
            )
          end

        end

      end
    end
  end
end
