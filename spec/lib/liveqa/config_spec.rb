require 'spec_helper'

describe LiveQA::Config do
  subject(:config) { LiveQA::Config.new(params) }

  describe  '#initialize' do
    let(:params) {{ api_key: SecureRandom.hex }}

    it { expect(config.valid!).to be_truthy }

    %i[api_key api_host api_version].each do |field|
      context "validate #{field}" do
        let(:params) {{ api_key: 'api-key', api_host: 'host', api_version: 'v1'  }.merge(field => '')}

        it { expect { config.valid! }.to raise_error(LiveQA::ConfigurationError, "#{field} can't be blank") }
      end
    end

    context 'format obfuscated_fields' do
      let(:params) {{ api_key: SecureRandom.hex, obfuscated_fields: %i[another_password password_confirmation] }}

      before { config.valid! }

      it { expect(config.obfuscated_fields).to match_array(%w[another_password password_confirmation password access_token api_key ccv credit_card_number cvv secret secret_token token]) }
    end

    context 'async_handler' do
      context 'sidekiq' do
        let(:params) {{
          api_key: SecureRandom.hex,
          async_handler: :sidekiq
        }}
        before { config.valid! }

        it { expect(config.async_handler).to be_a(LiveQA::AsyncHandlers::Sidekiq) }
      end
    end

  end
end
