# frozen_string_literal: true

require "spec_helper"

RSpec.describe DerivationEndpoint do
  it "has a version number" do
    expect(DerivationEndpoint::VERSION).not_to be nil
  end

  describe ".extend" do
    subject { example_class.extend(described_class) }

    let(:example_class) { Class.new }

    it "includes DerivationEndpoint::Attachment" do
      expect(example_class)
        .to receive(:include).with(DerivationEndpoint::Attachment)

      subject
    end
  end

  describe ".configure" do
    it { expect { |b| described_class.configure(&b) }.to yield_with_args }
  end

  describe ".config" do
    subject { described_class.config }

    it "returns DerivationEndpoint::Config" do
      expect(subject).to be_a(DerivationEndpoint::Config)
    end
  end

  describe ".derivation_path" do
    subject { described_class.derivation_path }

    context "with invalid config" do
      before { allow(DerivationEndpoint::Config).to receive(:valid?) { false } }

      it { is_expected.to eq(nil) }
    end

    context "with valid config" do
      before do
        described_class.configure do |config|
          config.host    = host
          config.prefix  = prefix
          config.encoder = encoder
          config.decoder = decoder
        end
      end

      let(:host)    { "foo" }
      let(:prefix)  { "bar" }
      let(:encoder) { proc {} }
      let(:decoder) { proc {} }

      it "returns prefix" do
        expect(subject).to eq("/#{prefix}")
      end
    end
  end


  describe ".base_url" do
    subject { described_class.base_url }

    context "with invalid config" do
      before { allow(DerivationEndpoint::Config).to receive(:valid?) { false } }

      it { is_expected.to eq(nil) }
    end

    context "with valid config" do
      before do
        described_class.configure do |config|
          config.host    = host
          config.prefix  = prefix
          config.encoder = encoder
          config.decoder = decoder
        end
      end

      let(:host)    { "foo" }
      let(:prefix)  { "bar" }
      let(:encoder) { proc {} }
      let(:decoder) { proc {} }

      it "returns host with derivation path" do
        expected_base_url = host + described_class.derivation_path

        expect(subject).to eq(expected_base_url)
      end
    end
  end
end
