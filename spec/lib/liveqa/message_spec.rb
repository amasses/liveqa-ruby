require 'spec_helper'

describe LiveQA::Message do
  subject(:base) { LiveQA::Message }

  describe '#base' do
    let(:expected_hash) {{
      message_id: kind_of(String),
      timestamp: kind_of(String),
      session_tracker_id: kind_of(String),
    }}

    it { expect(base.base).to match(expected_hash) }

    context 'with store' do
      before do
       LiveQA::Store.set(:session_tracker_id, 'hello')
     end

      let(:expected_hash) {{
        message_id: kind_of(String),
        timestamp: kind_of(String),
        session_tracker_id: 'hello',
      }}

      it { expect(base.base).to match(expected_hash) }
    end

    context 'with metadata' do


      let(:expected_hash) {{
        message_id: kind_of(String),
        timestamp: kind_of(String),
        session_tracker_id: kind_of(String),
        metadata: {
          deployment_id: 42
        }
      }}

      context 'hash type' do
        before do
          LiveQA.configurations.metadata = {
            deployment_id: 42
          }
        end

        it { expect(base.base).to match(expected_hash) }
      end

      context 'proc type' do
        before do
          LiveQA.configurations.metadata = {
            deployment_id: lambda { 84 / 2 }
          }
        end

        it { expect(base.base).to match(expected_hash) }
      end

      context 'proc & raise type' do
        before do
          LiveQA.configurations.metadata = {
            deployment_id: -> { 84 / 2 },
            other_id: -> { hello }
          }
        end

        it { expect(base.base).to match(expected_hash) }
      end
    end

  end

  describe '#extended' do
    let(:expected_hash) {{
      message_id: kind_of(String),
      timestamp: kind_of(String),
      session_tracker_id: kind_of(String),
      library: {
        name: "liveqa",
        language: "ruby",
        version: kind_of(String)
      },
      server: {
        host: kind_of(String),
        pid: kind_of(Numeric)
      }
    }}

    it { expect(base.extended).to match(expected_hash) }

    context 'with store' do
      before do
       LiveQA::Store.set(:session_tracker_id, 'hello')
       LiveQA::Store.set(:request,
        url:        'http://www.test.com/',
        ssl:        true,
        host:       'www.test.com',
        port:       4242,
        path:       '/',
        referrer:   'http://www.google.com/',
        method:     'GET',
        xhr:        false,
        user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
        ip:         '127.0.0.1',
      )
      LiveQA::Store.set(:worker,
        name: 'sidekiq',
        version: '5.0.4',
        queue: 'chameleon',
        class: 'LiveQA::AsyncHandlers::Sidekiq',
        id: '106a61579bc0e7e3d18e3b1c',
        created_at: '2017-12-15T03:45:10Z',
        process_at: '2017-12-15T03:45:10Z',
        args: ['LiveQA::Event']
      )

      LiveQA::Store.bulk_set(
        environment:    'production',
        server_software: 'WEBrick/1.3.1 (Ruby/2.2.7/2017-03-28)'
      )
     end

      let(:expected_hash) {{
        message_id: kind_of(String),
        timestamp: kind_of(String),
        session_tracker_id: 'hello',
        library: {
          name: 'liveqa',
          language: 'ruby',
          version: kind_of(String)
        },
        server: {
          host: kind_of(String),
          pid: kind_of(Numeric),
          software: 'WEBrick/1.3.1 (Ruby/2.2.7/2017-03-28)'
        },
        request: {
          url:        'http://www.test.com/',
          ssl:        true,
          host:       'www.test.com',
          port:       4242,
          path:       '/',
          referrer:   'http://www.google.com/',
          method:     'GET',
          xhr:        false,
          user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
          ip:         '127.0.0.1',
        },
        worker: {
          name: 'sidekiq',
          version: '5.0.4',
          queue: 'chameleon',
          class: 'LiveQA::AsyncHandlers::Sidekiq',
          id: '106a61579bc0e7e3d18e3b1c',
          created_at: '2017-12-15T03:45:10Z',
          process_at: '2017-12-15T03:45:10Z',
          args: ['LiveQA::Event']
        },
        environment: 'production'
      }}

      it { expect(base.extended).to match(expected_hash) }
    end
  end

end
