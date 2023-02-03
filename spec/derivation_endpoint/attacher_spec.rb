# frozen_string_literal: true

RSpec.describe DerivationEndpoint::Attacher do
  let(:attacher) { described_class.new(object, method, prefix, options) }

  let(:object)  { Class.new }
  let(:method)  { "bar" }
  let(:prefix)  { "baz" }
  let(:options) { {} }

  before { allow(object).to receive(method) { raise NoMethodError } }

  describe "#initialize" do
    subject { attacher }

    context "with a string prefix" do
      let(:prefix) { "foo" }

      context "with a hash options" do
        let(:options) { {} }

        it { is_expected.to be_a(described_class) }
      end

      context "without options" do
        let(:options) { nil }

        it { is_expected.to be_a(described_class) }
      end
    end

    context "with a symbol prefix" do
      let(:prefix) { "foo" }

      context "with a hash options" do
        let(:options) { {} }

        it { is_expected.to be_a(described_class) }
      end

      context "without options" do
        let(:options) { nil }

        it { is_expected.to be_a(described_class) }
      end
    end

    context "without prefix" do
      let(:prefix) { nil }

      context "with a hash options" do
        let(:options) { {} }

        it { is_expected.to be_a(described_class) }
      end

      context "without options" do
        let(:options) { nil }

        it { is_expected.to be_a(described_class) }
      end
    end

    context "with an invalid prefix" do
      let(:prefix) { 1 }

      it "raise an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#method_value" do
    subject { attacher.method_value }

    let(:method) { "foo" }

    context "when object does not respond to given method" do
      it "raise an error" do
        expect { subject }.to raise_error(NoMethodError)
      end
    end

    context "when object respond to given method" do
      before { allow(object).to receive(method) }

      it "executes method on object" do
        expect(object).to receive(method)

        subject
      end
    end
  end

  describe "#derivation_url" do
    subject { attacher.derivation_url }

    before do
      allow(object).to receive(method)

      DerivationEndpoint.configure do |c|
        c.encoder = ->(foo) { { foo: foo } }
        c.decoder = ->(bar) { { bar: bar } }
      end
    end

    context "without prefix" do
      let(:prefix)       { nil }
      let(:expected_url) { "/#{attacher.derivation_path}" }

      it { is_expected.to eq(expected_url) }
    end

    context "with prefix" do
      let(:prefix)       { "foo" }
      let(:prefixed_url) { "#{DerivationEndpoint.base_url}/#{prefix}" }
      let(:expected_url) { "#{prefixed_url}/#{attacher.derivation_path}" }

      it { is_expected.to eq(expected_url) }
    end
  end

  describe "#derivation_path" do
    subject { attacher.derivation_path }

    before do
      allow_any_instance_of(DerivationEndpoint::Config)
        .to receive(:encoder) { encoder }

      allow(object).to receive(method)
    end

    context "with a non proc encoder" do
      let(:encoder) { "foo" }

      it "raise an NoMethodError" do
        expect { subject }.to raise_error(NoMethodError)
      end
    end

    context "with a proc encoder" do
      before do
        DerivationEndpoint.configure { |c| c.encoder = encoder }
        allow(object).to receive(method) { method_value }
      end

      let(:encoder)      { ->(foo) { { foo: foo } } }
      let(:method_value) { "foo" }

      it "calls config proc encoder with method value" do
        expect(DerivationEndpoint.config.encoder).to receive(:call).with(method_value)
        subject
      end
    end
  end

  describe "#redirection_url" do
    subject { attacher.redirection_url }

    before do
      allow_any_instance_of(DerivationEndpoint::Config)
        .to receive(:decoder) { decoder }

      allow(object).to receive(method)
    end

    context "with a non proc decoder" do
      let(:decoder) { "foo" }

      it "raise an NoMethodError" do
        expect { subject }.to raise_error(NoMethodError)
      end
    end

    context "with a proc decoder" do
      before do
        DerivationEndpoint.configure { |c| c.decoder = decoder }
        allow(object).to receive(method) { method_value }
      end

      let(:decoder)         { ->(foo) { { foo: foo } } }
      let(:method_value)    { "foo" }
      let(:derivation_path) { attacher.derivation_path}

      it "calls config proc decoder with method value" do
        expect(DerivationEndpoint.config.decoder).to receive(:call).with(derivation_path, options)
        subject
      end
    end
  end
end
