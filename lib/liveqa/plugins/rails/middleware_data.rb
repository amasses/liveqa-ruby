module LiveQA
  module Plugins
    module Rails
      class MiddlewareData

        class << self

          def store_data(request)
            LiveQA::Store.bulk_set(
              environement: ::Rails.env
            )
            store_request_data(request)
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
            frameworks = LiveQA::Store.get(:frameworks) || []

            LiveQA::Store.set(
              :frameworks,
              frameworks.push(
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
