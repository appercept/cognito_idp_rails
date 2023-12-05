require "rails_helper"

RSpec.describe CognitoIdpRails::Configuration do
  subject(:configuration) { described_class.new }

  describe "#after_login_route" do
    subject(:after_login_route) { configuration.after_login_route }

    it "defaults to /" do
      is_expected.to eq("/")
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
      is_expected.to eq("/")
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

  describe "#on_logout" do
    subject(:on_logout) { configuration.on_logout }

    it { is_expected.to be_a(Proc) }

    context "when specified" do
      before do
        configuration.on_logout = new_on_logout
      end

      let(:new_on_logout) { instance_double(Proc) }

      it { is_expected.to eq(new_on_logout) }
    end
  end

  describe "#on_valid_login" do
    subject(:on_valid_login) { configuration.on_valid_login }

    it { is_expected.to be_a(Proc) }

    context "when specified" do
      before do
        configuration.on_valid_login = new_on_valid_login
      end

      let(:new_on_valid_login) { instance_double(Proc) }

      it { is_expected.to eq(new_on_valid_login) }
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
