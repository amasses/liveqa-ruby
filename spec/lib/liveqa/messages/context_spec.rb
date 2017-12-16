require 'spec_helper'

describe LiveQA::Messages::Context do
  subject(:context) { LiveQA::Messages::Context }

  describe '#to_h' do
    context 'without store' do
      let(:expected_hash) {{
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

      it { expect(context.to_h).to match(expected_hash) }
    end

    context 'with store values' do
      before do
        LiveQA::Store.set(:request,
          url:        'http://www.test.com/',
          ssl:        true,
          host:       'www.test.com',
          port:       4242,
          path:       '/',
          referrer:   'http://www.google.com/',
          method:     'GET',
          xhr:        false,
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
          user_agent:      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
          ip:              '127.0.0.1',
          environement:    'production',
          server_software: 'WEBrick/1.3.1 (Ruby/2.2.7/2017-03-28)'
        )
      end

      let(:expected_hash) {{
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
          xhr:        false
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
        user_agent:   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
        ip:           '127.0.0.1',
        environement: 'production'
      }}

      it { expect(context.to_h).to match(expected_hash) }
    end
  end

end
