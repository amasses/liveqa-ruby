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
        request: {
          id: '42a'
        }
      }}

      it { expect(LiveQA::Store.store).to match(expected) }
    end

    context 'update the store' do
      before do
        LiveQA::Store.set(:request, { xhr: false })
      end
      before { middleware.store_data(request) }

      let(:expected) {{
        request: {
          id: '42a',
          xhr: false
        }
      }}

      it { expect(LiveQA::Store.store).to match(expected) }
    end
  end
end
