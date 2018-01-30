require 'spec_helper'

describe LiveQA::Config do
  subject(:config) { LiveQA::Config.new(params) }

  describe  '#initialize' do
    let(:params) {{ account_token: 'acc_xx', space_name: 'LiveQA', environment_name: 'test' }}

    it { expect(config.valid!).to be_truthy }

    %i[account_token environment_name api_host api_version].each do |field|
      context "validate #{field}" do
        let(:params) {{ account_token: 'acc_xx', space_name: 'LiveQA', environment_name: 'test', api_host: 'host', api_version: 'v1'  }.merge(field => '')}

        it { expect { config.valid! }.to raise_error(LiveQA::ConfigurationError, "#{field} can't be blank") }
      end
    end

    context 'format obfuscated_fields' do
      let(:params) {{ account_token: 'acc_xx', space_name: 'LiveQA', environment_name: 'test', obfuscated_fields: %i[another_password password_confirmation] }}

      before { config.valid! }

      it { expect(config.obfuscated_fields).to match_array(%w[another_password password_confirmation password access_token api_key authenticity_token ccv credit_card_number cvv secret secret_token token]) }
    end

    context 'async_handler' do
      context 'sidekiq' do
        let(:params) {{
          account_token: 'acc_xx',
          space_name: 'LiveQA',
          environment_name: 'test',
          async_handler: :sidekiq
        }}
        before { config.valid! }

        it { expect(config.async_handler).to be_a(LiveQA::AsyncHandlers::Sidekiq) }
      end
    end

  end
end
