require 'spec_helper'
require 'rack'
require 'liveqa/plugins/rack/middleware'

describe LiveQA::Plugins::Rack::Middleware do

  let(:app) { RackApp.new }
  let(:middleware) { LiveQA::Plugins::Rack::Middleware.new(app) }

  context 'reset the store' do
    before do
      2.times { middleware.call({}) }
    end

    it { expect(app.last_value).to eq(1) }
    it { expect(LiveQA::Store.store).to eq({}) }
  end

  it 'reset the store with error' do
    expect { middleware.call(error: true) }.to raise_error(RuntimeError)

    expect(LiveQA::Store.store).to eq({})
  end

end
