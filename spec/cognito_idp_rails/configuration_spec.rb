require "rails_helper"

RSpec.describe CognitoIdpRails::Configuration do
  subject(:configuration) { described_class.new }

  describe "#after_login_route" do
    subject(:after_login_route) { configuration.after_login_route }

    it "defaults to /" do
      expect(subject).to eq("/")
    end

    context "when specified" do
      before do
        configuration.after_login_route = new_route
      end

      let(:new_route) { "/new_route" }

      it { is_expected.to eq(new_route) }
    end
  end

  describe "#after_logout_route" do
    subject(:after_logout_route) { configuration.after_logout_route }

    it "defaults to /" do
      expect(subject).to eq("/")
    end

    context "when specified" do
      before do
        configuration.after_logout_route = new_route
      end

      let(:new_route) { "/new_route" }

      it { is_expected.to eq(new_route) }
    end
  end

  describe "#domain" do
    subject(:domain) { configuration.domain }

    it { is_expected.to be_nil }

    context "when specified" do
      before do
        configuration.domain = new_domain
      end

      let(:new_domain) { "new.example.com" }

      it { is_expected.to eq(new_domain) }
    end
  end

  describe "#client_id" do
    subject(:client_id) { configuration.client_id }

    it { is_expected.to be_nil }

    context "when specified" do
      before do
        configuration.client_id = new_client_id
      end

      let(:new_client_id) { "new-client-id" }

      it { is_expected.to eq(new_client_id) }
    end
  end

  describe "#client_secret" do
    subject(:client_secret) { configuration.client_secret }

    it { is_expected.to be_nil }

    context "when specified" do
      before do
        configuration.client_secret = new_client_secret
      end

      let(:new_client_secret) { "new-client-secret" }

      it { is_expected.to eq(new_client_secret) }
    end
  end

  describe "#after_login" do
    subject(:after_login) { configuration.after_login }

    it { is_expected.to be_a(Proc) }

    context "when specified" do
      before do
        configuration.after_login = new_after_login
      end

      let(:new_after_login) { instance_double(Proc) }

      it { is_expected.to eq(new_after_login) }
    end
  end

  describe "#before_logout" do
    subject(:before_logout) { configuration.before_logout }

    it { is_expected.to be_a(Proc) }

    context "when specified" do
      before do
        configuration.before_logout = new_before_logout
      end

      let(:new_before_logout) { instance_double(Proc) }

      it { is_expected.to eq(new_before_logout) }
    end
  end

  describe "#on_login_error" do
    subject(:on_login_error) { configuration.on_login_error }

    it { is_expected.to be_a(Proc) }

    context "when specified" do
      before do
        configuration.on_login_error = new_on_login_error
      end

      let(:new_on_login_error) { instance_double(Proc) }

      it { is_expected.to eq(new_on_login_error) }
    end
  end

  describe "#validate!" do
    context "when all required attributes are set" do
      before do
        configuration.domain = "auth.example.com"
        configuration.client_id = "client-1"
        configuration.client_secret = "secret"
      end

      it "does not raise" do
        expect { configuration.validate! }.not_to raise_error
      end
    end

    context "when domain is missing" do
      before do
        configuration.client_id = "client-1"
        configuration.client_secret = "secret"
      end

      it "raises a ConfigurationError" do
        expect { configuration.validate! }.to raise_error(
          CognitoIdpRails::ConfigurationError, "Missing required configuration: domain"
        )
      end
    end

    context "when multiple attributes are missing" do
      it "raises a ConfigurationError listing all missing attributes" do
        expect { configuration.validate! }.to raise_error(
          CognitoIdpRails::ConfigurationError, "Missing required configuration: domain, client_id, client_secret"
        )
      end
    end
  end

  describe "#scope" do
    subject(:scope) { configuration.scope }

    it { is_expected.to be_nil }

    context "when specified" do
      before do
        configuration.scope = new_scope
      end

      let(:new_scope) { "new scope" }

      it { is_expected.to eq(new_scope) }
    end
  end
end
