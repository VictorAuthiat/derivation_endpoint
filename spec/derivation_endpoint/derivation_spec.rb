# frozen_string_literal: true

require "spec_helper"

RSpec.describe DerivationEndpoint::Derivation do
  before do
    DerivationEndpoint.configure do |config|
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

  describe ".decode" do
    subject { described_class.decode(params) }

    let(:params) { DerivationEndpoint::Serializer.encode({ path: path, options: options }) }
    let(:path)    { "foo" }
    let(:options) { { bar: "baz" } }

    it "calls decoder proc with path and options" do
      expect(decoder).to receive(:call).with(path, options)
      subject
    end
  end

  describe ".call" do
    subject { described_class.new.call(env) }

    let(:fake_request_class) { Class.new }
    let(:fake_request)       { fake_request_class.new }
    let(:env)                { "foo" }

    before do
      allow(Rack::Request).to receive(:new)      { fake_request }
      allow(fake_request).to receive(:get?)      { get }
      allow(fake_request).to receive(:head?)     { head }
      allow(fake_request).to receive(:path_info) { path_info }
    end

    context "without a get request" do
      let(:get) { false }

      context "without head" do
        let(:head) { false }

        it "is a 405" do
          expect(subject[0]).to eq(405)
          expect(subject[1]["Content-Type"]).to eq("text/plain")
          expect(subject[2][0]).to eq("Method not allowed")
        end
      end

      context "with head" do
        let(:head)      { true }
        let(:path_info) { "" }

        context "when ArgumentError occured" do
          before { allow(fake_request).to receive(:path_info) { raise ArgumentError } }

          it "is a 405" do
            expect(subject[0]).to eq(405)
            expect(subject[1]["Content-Type"]).to eq("text/plain")
            expect(subject[2][0]).to eq("Method not allowed")
          end
        end

        context "without path info" do
          it "is a 404" do
            expect(subject[0]).to eq(404)
            expect(subject[1]["Content-Type"]).to eq("text/plain")
            expect(subject[2][0]).to eq("Source not found")
          end
        end

        context "with path info" do
          let(:path)         { "foo" }
          let(:options)      { { bar: "baz" } }
          let(:path_info)    { DerivationEndpoint::Serializer.encode({ path: path, options: options }) }
          let(:decoded_path) { DerivationEndpoint.config.decoder.call(path, options) }

          it "decodes last path info and redirect to the result", aggregate_failures: true do
            expect(subject[0]).to eq(302)
            expect(subject[1]["Location"]).to eq(decoded_path)
            expect(subject[2][0]).to eq(nil)
          end
        end
      end
    end
  end
end
