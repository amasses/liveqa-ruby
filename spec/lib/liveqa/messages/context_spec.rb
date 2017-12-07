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
        LiveQA::Store.bulk_set(
          url:            'http://www.test.com/',
          ssl:            true,
          host:           'www.test.com',
          port:           4242,
          path:           '/',
          referrer:       'http://www.google.com/',
          request_method: 'GET',
          xhr:            false,
          user_agent:     'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
          ip:             '127.0.0.1'
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
          pid: kind_of(Numeric)
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
        user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36',
        ip:         '127.0.0.1'
      }}

      it { expect(context.to_h).to match(expected_hash) }
    end
  end

end
