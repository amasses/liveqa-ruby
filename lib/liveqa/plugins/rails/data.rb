module LiveQA
  module Plugins
    module Rails
      class Data

        class << self

          def store_data
            LiveQA::Store.bulk_set(
              environment: ::Rails.env
            )
            store_framework
          end

          private

          def store_framework
            stack = LiveQA::Store.get(:stack) || []

            return if stack.any? { |values| values[:name] == 'rails' }

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
