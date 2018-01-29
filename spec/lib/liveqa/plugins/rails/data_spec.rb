require 'spec_helper'
require 'rails'
require 'liveqa/plugins/rails/data'

describe LiveQA::Plugins::Rails::Data do

  let(:middleware) { LiveQA::Plugins::Rails::Data }

  describe '#store_data' do

    context 'blank store' do
      before { middleware.store_data }

      let(:expected) {{
        environment: kind_of(String),
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
        LiveQA::Store.set(:stack, [{ name: 'rack' }])
      end
      before { middleware.store_data }

      let(:expected) {{
        environment: kind_of(String),
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

    context 'avoid duplicate data in store' do
      before do
        LiveQA::Store.set(:environment, 'production')
        LiveQA::Store.set(:stack, [{ name: 'rails', version: '5.0.1' }])
      end
      before { middleware.store_data }

      let(:expected) {{
        environment: kind_of(String),
        stack: [
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
