require "rails_helper"

RSpec.describe CognitoIdpRails do
  describe ".client" do
    subject(:client) { described_class.client }

    let(:client_id) { "client-1" }
    let(:client_secret) { "client-secret" }
    let(:domain) { "id.example.com" }

    before do
      CognitoIdpRails.configure do |config|
        config.client_id = client_id
        config.client_secret = client_secret
        config.domain = domain
      end
    end

    it { expect(client.client_id).to eq(client_id) }
    it { expect(client.client_secret).to eq(client_secret) }
    it { expect(client.domain).to eq(domain) }
  end

  describe ".configure" do
    it "yields configuration to a block" do
      expect { |b| described_class.configure(&b) }.to yield_with_args(described_class.configuration)
    end
  end
end
