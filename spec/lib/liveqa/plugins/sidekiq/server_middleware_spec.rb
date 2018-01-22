require 'spec_helper'
require 'sidekiq'
require 'liveqa/plugins/sidekiq/server_middleware'

describe LiveQA::Plugins::Sidekiq::ServerMiddleware do

  let(:middleware) { LiveQA::Plugins::Sidekiq::ServerMiddleware.new }

  describe '#call' do
    let(:job_attr) {{
       'class' => 'MyWorker',
       'args' => ['42'],
       'retry' => 3,
       'queue' => 'default',
       'jid' => '24cc849f71325b62ef470901',
       'created_at' => 1513299839.2563882,
       'liveqa_store' =>  {
          'tracker_id' => '06a09f70-6219-4860-babc-18aa47a62f7f',
          'user_agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
          'ip' => '127.0.0.1'
        },
       'enqueued_at' => 1513300328.8271549,
       'error_message' => 'exit',
       'error_class' => 'SystemExit',
       'failed_at' => 1513300166.646098,
       'retry_count' => 1,
       'retried_at' => 1513300238.6037261
    }}

    context 'expected to be clean at the end' do
      before { middleware.call('MyWorker', job_attr, 'default') {} }

      it { expect(LiveQA::Store.store).to be_empty }
    end

    context 'expected to be clean at the end' do
      before { allow(LiveQA::Store).to receive(:clear!).and_return(true) }
      before { middleware.call('MyWorker', job_attr, 'default') {} }

      let(:expected) {{
        tracker_id: '06a09f70-6219-4860-babc-18aa47a62f7f',
        user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
        ip: '127.0.0.1',
        worker:  {
          name: 'sidekiq',
          version: kind_of(String),
          queue: 'default',
          class: 'MyWorker',
          id: '24cc849f71325b62ef470901',
          created_at: '2017-12-15T01:03:59.256Z',
          process_at: '2017-12-15T01:12:08.827Z',
          args: ['42'],
          retried: true,
          retry_number: 1,
          failed_at: '2017-12-15T01:09:26.646Z'
        },
      }}

      it { expect(LiveQA::Store.store).to match(expected) }
    end
  end

end
