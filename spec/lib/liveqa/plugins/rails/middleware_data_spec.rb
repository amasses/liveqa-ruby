require 'spec_helper'
require 'rails'
require 'liveqa/plugins/rails/middleware_data'

describe LiveQA::Plugins::Rails::MiddlewareData do

  let(:middleware) { LiveQA::Plugins::Rails::MiddlewareData }

  describe '#store_data' do
    let(:request) do
      double('request',
        env: {
          'action_dispatch.request_id' => '42a'
        }
      )
    end

    context 'blank store' do
      before { middleware.store_data(request) }

      let(:expected) {{
        environement: kind_of(String),
        request: {
          id: '42a'
        },
        stack: [
          {
            name: 'rails',
            version: kind_of(String)
          }
        ]
      }}

      it { expect(LiveQA::Store.store).to match(expected) }
    end

    context 'update the store' do
      before do
        LiveQA::Store.set(:request, { xhr: false })
        LiveQA::Store.set(:stack, [{ name: 'rack' }])
      end
      before { middleware.store_data(request) }

      let(:expected) {{
        environement: kind_of(String),
        request: {
          id: '42a',
          xhr: false
        },
        stack: [
          {
            name: 'rack'
          },
          {
            name: 'rails',
            version: kind_of(String)
          }
        ]
      }}

      it { expect(LiveQA::Store.store).to match(expected) }
    end


  end

end
