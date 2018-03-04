require 'spec_helper'
require 'rack'
require 'liveqa/plugins/rack/middleware'

describe LiveQA::Plugins::Rack::Middleware do

  let(:app) { lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['All responses are OK']] } }
  let(:middleware) { LiveQA::Plugins::Rack::Middleware.new(app) }

  context 'reset the store' do
    before do
      2.times { middleware.call({}) }
    end

    #it { expect(app.last_value).to eq(1) }
    it { expect(LiveQA::Store.store).to eq({}) }
  end

  it 'reset the store with error' do
    allow(middleware).to receive(:call).and_raise(RuntimeError)
    expect { middleware.call(error: true) }.to raise_error(RuntimeError)

    expect(LiveQA::Store.store).to eq({})
  end

  it 'includes the secure flag in the cookie for a HTTPS connection' do
    response =  middleware.call({'HTTP_X_FORWARDED_SSL' => 'on'})
    expect(response[1]['Set-Cookie']).to match(%r{liveqa_tracker_id.*secure.*})
  end

end
