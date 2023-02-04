# frozen_string_literal: true

require "spec_helper"

RSpec.describe DerivationEndpoint::Attachment do
  let(:example_class)    { Class.new }
  let(:example_instance) { example_class.new }

  describe ".included" do
    subject { example_class.include(described_class) }

    it "extends included class with ClassMethods" do
      expect(example_class)
        .to receive(:extend).with(DerivationEndpoint::Attachment::ClassMethods)

      subject
    end

    it "defines derivation_endpoint method" do
      subject
      expect(example_class).to respond_to(:derivation_endpoint)
    end
  end

  describe ".derivation_endpoint" do
    subject { example_class.derivation_endpoint(method, prefix: prefix, options: options) }
    before  { example_class.include(described_class) }

    context "whith invalid parameters" do
      let(:method)  { nil }
      let(:prefix)  { nil }
      let(:options) { nil }

      context "when method is not a string or a symbol" do
        let(:method) { [] }

        it "raises a validation error" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when prefix is not a string, symbol or nil" do
        let(:prefix) { [] }

        it "raises a validation error" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when options is not a hash or nil" do
        let(:options) { [] }

        it "raises a validation error" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    context "whith valid parameters" do
      let(:method)  { "foo" }
      let(:prefix)  { "bar" }
      let(:options) { { baz: :buz } }

      it "defines derivation methods", aggregate_failures: true do
        subject

        expect(example_instance).to respond_to(:"#{method}_derivation_url")
        expect(example_instance).to respond_to(:"#{method}_redirection_url")
      end
    end
  end

  describe "derivation methods" do
    subject { example_instance.public_send("#{method}_#{attacher_method}") }

    before do
      DerivationEndpoint.configure do |config|
        config.host    = "foo"
        config.prefix  = "bar"
        config.encoder = proc {}
        config.decoder = proc {}
      end

      example_class.include(described_class)
      example_class.derivation_endpoint(method, prefix: prefix, options: options)
      allow(example_instance).to receive(method)
    end

    let(:method)  { "foo" }
    let(:prefix)  { "bar" }
    let(:options) { { baz: :buz } }

    DerivationEndpoint::Attachment::ClassMethods::ATTACHER_DERIVATION_METHODS.each do |attacher_method|
      describe "#{attacher_method}" do
        let(:attacher_method) { attacher_method }

        it "instanciates attacher with given params and call method on it", aggregate_failures: true do
          expect(DerivationEndpoint::Attacher).to receive(:new).with(example_instance, method, prefix, options).and_call_original
          expect_any_instance_of(DerivationEndpoint::Attacher).to receive(attacher_method).and_call_original

          subject
        end
      end
    end
  end
end
