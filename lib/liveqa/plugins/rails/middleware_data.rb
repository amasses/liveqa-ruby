module LiveQA
  module Plugins
    module Rails
      class MiddlewareData

        class << self

          def store_data(request = nil)
            LiveQA::Store.bulk_set(
              environement: ::Rails.env
            )
            store_request_data(request) if request
            store_framework
          end

          private

          def store_request_data(request)
            object = LiveQA::Store.get(:request) || {}

            LiveQA::Store.set(
              :request,
              object.merge(id: request.env['action_dispatch.request_id'])
            )
          end

          def store_framework
            stack = LiveQA::Store.get(:stack) || []

            LiveQA::Store.set(
              :stack,
              stack.push(
                name: 'rails',
                version: ::Rails.version
              )
            )
          end

        end

      end
    end
  end
end
