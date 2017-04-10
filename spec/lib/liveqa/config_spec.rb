require 'spec_helper'

describe LiveQA::Config do
  subject(:config) { LiveQA::Config.new(params) }

  describe  '#initialize' do
    let(:params) {{ api_key: 'LWbtEmD3Q1INrlBgMZ_pTVEXHt2B8UuyLF3S1wfQ3W3Lcl6NY3rX4jrL' }}

    it { expect(config.valid!).to be_truthy }

    %i[api_key api_host api_version].each do |field|
      context "validate #{field}" do
        let(:params) {{ api_key: 'api-key', api_host: 'host', api_version: 'v1'  }.merge(field => '')}

        it { expect { config.valid! }.to raise_error(LiveQA::ConfigurationError, "#{field} can't be blank") }
      end
    end

  end
end
