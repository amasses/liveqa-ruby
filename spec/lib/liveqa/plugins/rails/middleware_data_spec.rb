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
        environement: 'development',
        request: {
          id: '42a'
        },
        frameworks: [
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
        LiveQA::Store.set(:frameworks, [{ name: 'rack' }])
      end
      before { middleware.store_data(request) }

      let(:expected) {{
        environement: 'development',
        request: {
          id: '42a',
          xhr: false
        },
        frameworks: [
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
